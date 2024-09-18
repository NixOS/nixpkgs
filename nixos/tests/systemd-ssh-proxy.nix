{
  pkgs,
  lib,
  config,
  ...
}:
# This tests that systemd-ssh-proxy and systemd-ssh-generator work correctly with:
# - a local unix socket on the same system
# - a vsock socket inside a vm
let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;
  qemu = config.nodes.virthost.virtualisation.qemu.package;
  iso =
    (import ../lib/eval-config.nix {
      inherit (pkgs.stdenv.hostPlatform) system;
      modules = [
        ../modules/installer/cd-dvd/iso-image.nix
        {
          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "prohibit-password";
          };
          isoImage.isoBaseName = lib.mkForce "nixos";
          isoImage.makeBiosBootable = true;
          system.stateVersion = lib.trivial.release;
        }
      ];
    }).config.system.build.isoImage;
in
{
  name = "systemd-ssh-proxy";
  meta.maintainers = with pkgs.lib.maintainers; [ marie ];

  nodes = {
    virthost = {
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "prohibit-password";
      };
      users.users = {
        root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
        nixos = {
          isNormalUser = true;
        };
      };
      systemd.services.test-vm = {
        script = "${lib.getExe qemu} --nographic -smp 1 -m 512 -cdrom ${iso}/iso/nixos.iso -device vhost-vsock-pci,guest-cid=3 -smbios type=11,value=\"io.systemd.credential:ssh.authorized_keys.root=${snakeOilEd25519PublicKey}\"";
      };
    };
  };

  testScript = ''
    virthost.systemctl("start test-vm.service")

    virthost.succeed("mkdir -p ~/.ssh")
    virthost.succeed("cp '${snakeOilEd25519PrivateKey}' ~/.ssh/id_ed25519")
    virthost.succeed("chmod 600 ~/.ssh/id_ed25519")

    with subtest("ssh into a vm with vsock"):
      virthost.wait_until_succeeds("systemctl is-active test-vm.service")
      virthost.wait_until_succeeds("ssh -i ~/.ssh/id_ed25519 vsock/3 echo meow | grep meow")
      virthost.wait_until_succeeds("ssh -i ~/.ssh/id_ed25519 vsock/3 shutdown now")
      virthost.wait_until_succeeds("! systemctl is-active test-vm.service")

    with subtest("elevate permissions using local ssh socket"):
      virthost.wait_for_unit("sshd-unix-local.socket")
      virthost.succeed("sudo --user=nixos mkdir -p /home/nixos/.ssh")
      virthost.succeed("cp ~/.ssh/id_ed25519 /home/nixos/.ssh/id_ed25519")
      virthost.succeed("chmod 600 /home/nixos/.ssh/id_ed25519")
      virthost.succeed("chown nixos /home/nixos/.ssh/id_ed25519")
      virthost.succeed("sudo --user=nixos ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -i /home/nixos/.ssh/id_ed25519 root@.host whoami | grep root")
  '';
}
