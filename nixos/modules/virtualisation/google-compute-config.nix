{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    boolToString
    mkDefault
    mkIf
    optional
    readFile
    ;
in

{
  imports = [
    ../profiles/headless.nix
    ../profiles/qemu-guest.nix
  ];

  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
  };

  boot.growPartition = true;
  boot.kernelParams = [
    "console=ttyS0"
    "panic=1"
    "boot.panic_on_fail"
  ];
  boot.initrd.kernelModules = [ "virtio_scsi" ];
  boot.kernelModules = [
    "virtio_pci"
    "virtio_net"
  ];

  # Generate a GRUB menu.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using SSH keys
  # and disable password authentication in general
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = mkDefault "prohibit-password";
  services.openssh.settings.PasswordAuthentication = mkDefault false;

  # enable OS Login. This also requires setting enable-oslogin=TRUE metadata on
  # instance or project level
  security.googleOsLogin.enable = true;

  # Use GCE udev rules for dynamic disk volumes
  services.udev.packages = [ pkgs.google-guest-configs ];
  services.udev.path = [ pkgs.google-guest-configs ];

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

  systemd.packages = [ pkgs.google-guest-agent ];
  systemd.services.google-guest-agent = {
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config.environment.etc."default/instance_configs.cfg".source ];
    path = optional config.users.mutableUsers pkgs.shadow;
  };
  systemd.services.google-startup-scripts.wantedBy = [ "multi-user.target" ];
  systemd.services.google-shutdown-scripts.wantedBy = [ "multi-user.target" ];

  security.sudo.extraRules = mkIf config.users.mutableUsers [
    {
      groups = [ "google-sudoers" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  security.sudo-rs.extraRules = mkIf config.users.mutableUsers [
    {
      groups = [ "google-sudoers" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  users.groups.google-sudoers = mkIf config.users.mutableUsers { };

  boot.extraModprobeConfig = readFile "${pkgs.google-guest-configs}/etc/modprobe.d/gce-blacklist.conf";

  environment.etc."sysctl.d/60-gce-network-security.conf".source = "${pkgs.google-guest-configs}/etc/sysctl.d/60-gce-network-security.conf";

  environment.etc."default/instance_configs.cfg".text = ''
    [Accounts]
    useradd_cmd = useradd -m -s /run/current-system/sw/bin/bash -p * {user}

    [Daemons]
    accounts_daemon = ${boolToString config.users.mutableUsers}

    [InstanceSetup]
    # Make sure GCE image does not replace host key that NixOps sets.
    set_host_keys = false

    [MetadataScripts]
    default_shell = ${pkgs.stdenv.shell}

    [NetworkInterfaces]
    dhclient_script = ${pkgs.google-guest-configs}/bin/google-dhclient-script
    # We set up network interfaces declaratively.
    setup = false
  '';
}
