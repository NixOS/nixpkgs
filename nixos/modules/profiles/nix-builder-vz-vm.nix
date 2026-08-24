/*
  The Linux remote-builder profile, on Apple's Virtualization.framework.

  The vzvm counterpart to `./nix-builder-vm.nix`:

  - Backend-neutral half lives in `./nix-builder.nix`.
  - everything below is what differs from the QEMU backend.

  Main differences:

  - `networking.nameservers = [ "8.8.8.8" ]` is not needed.
    vz uses the host's NAT, which provides working DNS.
  - `virtualisation.graphics = false`: no display support in vz
  - `virtualisation.useNixStoreImage`: vz only supports nix store image
*/
{
  config,
  lib,
  ...
}:

let
  cfg = config.virtualisation.darwin-builder;

  keysDirectory = "/var/keys";
  keysMountUnit = "var-keys.mount";
in

{
  imports = [
    ./nix-builder.nix
    ../virtualisation/vz-vm.nix
  ];

  config = {
    virtualisation.vz.forwardPorts = [
      {
        host.address = "127.0.0.1";
        host.port = cfg.hostPort;
        # `systemd-ssh-generator` serves SSH on vsock port 22 in the guest.
        guest.port = 22;
      }
    ];

    # The guest console belongs where a Mac user looks for service logs. Switch to `file`
    # for a complete record: the unified log drops messages under bursts.
    virtualisation.vz.console = lib.mkDefault "log";
    virtualisation.vz.consoleLog = lib.mkDefault "./console.log";

    # Our raw image must keep the `.qcow2` name nix-darwin's `ephemeral` wipes; vzvm checks
    # the magic bytes and refuses a genuine leftover qcow2 rather than misreading it.
    virtualisation.vz.diskImage = "./${config.networking.hostName}.qcow2";

    # authorized keys come via virtiofs. fix uid and mode for sshd's ownership checks.
    systemd.services.copy-builder-keys = {
      description = "Stage builder SSH keys where sshd will accept them";
      wantedBy = [ "multi-user.target" ];
      requires = [ keysMountUnit ];
      after = [ keysMountUnit ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        install -d -m 0755 -o root -g root /run/builder-keys
        for key in ${keysDirectory}/*.pub; do
          [ -e "$key" ] || continue
          install -m 0444 -o root -g root "$key" /run/builder-keys/
        done
      '';
    };

    # The dependency belongs on the per-connection service, not on the socket.
    systemd.services."sshd-vsock@" = {
      overrideStrategy = "asDropin";
      requires = [ "copy-builder-keys.service" ];
      # ssh works before DHCP finishes
      # don't accept build requests when substitution would still fail
      wants = [ "network-online.target" ];
      after = [
        "copy-builder-keys.service"
        "network-online.target"
      ];
    };

    services.openssh.authorizedKeysFiles = lib.mkForce [
      "/run/builder-keys/%u_ed25519.pub"
    ];
  };
}
