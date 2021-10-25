{ config, lib, pkgs, ... }:
with lib;
let
  gce = pkgs.google-compute-engine;
  agent = pkgs.google-compute-guest-agent;
  guest-configs = pkgs.google-compute-configs;
in
{
  imports = [
    ../profiles/headless.nix
    ../profiles/qemu-guest.nix
  ];

  environment.etc."sysctl.d/11-gce-network-security.conf".source = "${gce}/sysctl.d/11-gce-network-security.conf";

  environment.etc."default/instance_configs.cfg".text = ''
    [Accounts]
    deprovision_remove = false
    gpasswd_add_cmd = gpasswd -a {user} {group}
    gpasswd_remove_cmd = gpasswd -d {user} {group}
    groupadd_cmd = groupadd {group}
    useradd_cmd = useradd -m -s ${pkgs.bash}/bin/bash -p * {user}
    userdel_cmd = userdel -r {user}

    [Daemons]
    accounts_daemon = false
    clock_skew_daemon = true
    network_daemon = true
    oslogin_daemon = false

    [InstanceSetup]
    host_key_types = ecdsa,ed25519,rsa
    network_enabled = true
    optimize_local_ssd = false
    set_boto_config = true
    set_host_keys = false
    set_multiqueue = true

    [IpForwarding]
    ethernet_proto_id = 66
    ip_aliases = false
    target_instance_ips = false

    [MetadataScripts]
    default_shell = ${pkgs.bash}/bin/bash
    run_dir =
    shutdown = true
    startup = true

    [NetworkInterfaces]
    dhcp_command =
    ip_forwarding = false
    setup = false'';

  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
  };

  boot.growPartition = true;
  boot.kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
  boot.initrd.kernelModules = [ "virtio_scsi" ];
  boot.kernelModules = [ "virtio_pci" "virtio_net" ];

  # Generate a GRUB menu.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using SSH keys
  # and disable password authentication in general
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
  services.openssh.passwordAuthentication = mkDefault false;

  # enable OS Login. This also requires setting enable-oslogin=TRUE metadata on
  # instance or project level
  security.googleOsLogin.enable = true;

  # Use GCE udev rules for dynamic disk volumes
  services.udev.packages = [ gce ];

  # Force getting the hostname from Google Compute.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  # Rely on GCP's firewall instead
  networking.firewall.enable = mkDefault false;

  # Configure default metadata hostnames
  networking.extraHosts = ''
    169.254.169.254 metadata.google.internal metadata
  '';

  networking.timeServers = [ "metadata.google.internal" ];

  networking.usePredictableInterfaceNames = false;

  # GC has 1460 MTU
  networking.interfaces.eth0.mtu = 1460;

  # Used by NixOps
  systemd.services.fetch-instance-ssh-keys = {
    description = "Fetch host keys and authorized_keys for root user";

    wantedBy = [ "sshd.service" ];
    before = [ "sshd.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.wget ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.runCommand "fetch-instance-ssh-keys" { } ''
        cp ${./fetch-instance-ssh-keys.bash} $out
        chmod +x $out
        ${pkgs.shfmt}/bin/shfmt -i 4 -d $out
        ${pkgs.shellcheck}/bin/shellcheck $out
        patchShebangs $out
      '';
      PrivateTmp = true;
      StandardError = "journal+console";
      StandardOutput = "journal+console";
    };
  };

  systemd.services.google-guest-agent = {
    after = [ "network-online.target" "network.target" "rsyslog.service" ];
    wants = [ "network-online.target" ];
    before = [ "sshd.service" ];
    wantedBy = [ "sshd.service" "multi-user.target" ];
    serviceConfig = {
      Type = "notify";
      ExecStart = "${agent}/bin/google_guest_agent";
      OOMScoreAdjust = "-999";
      Restart = "always";
      StandardOutput = "journal+console";
    };
  };

  systemd.services.google-startup-scripts = {
    description = "Google Compute Engine Startup Scripts";
    after = [ "network-online.target" "google-guest-agent.service" "rsyslog.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${agent}/bin/google_metadata_script_runner startup";
      KillMode = "process";
      StandardOutput = "journal+console";
    };
  };

  systemd.services.google-shutdown-scripts = {
    description = "Google Compute Engine Shutdown Scripts";
    after = [ "network-online.target" "google-guest-agent.service" "rsyslog.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${agent}/bin/google_metadata_script_runner shutdown";
      TimoutStopSec = "0";
      KillMode = "process";
      StandardOutput = "journal+console";
    };
  };

}
