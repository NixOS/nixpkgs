{ config, lib, pkgs, ... }:
with lib;
let
  gce = pkgs.google-compute-engine;
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

  # Make sure GCE image does not replace host key that NixOps sets
  environment.etc."default/instance_configs.cfg".text = lib.mkDefault ''
    [InstanceSetup]
    set_host_keys = false
  '';

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

  systemd.services.google-instance-setup = {
    description = "Google Compute Engine Instance Setup";
    after = [ "network-online.target" "network.target" "rsyslog.service" ];
    before = [ "sshd.service" ];
    path = with pkgs; [ coreutils ethtool openssh ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_instance_setup";
      StandardOutput="journal+console";
      Type = "oneshot";
    };
    wantedBy = [ "sshd.service" "multi-user.target" ];
  };

  systemd.services.google-network-daemon = {
    description = "Google Compute Engine Network Daemon";
    after = [ "network-online.target" "network.target" "google-instance-setup.service" ];
    path = with pkgs; [ iproute2 ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_network_daemon";
      StandardOutput="journal+console";
      Type="simple";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.google-clock-skew-daemon = {
    description = "Google Compute Engine Clock Skew Daemon";
    after = [ "network.target" "google-instance-setup.service" "google-network-daemon.service" ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_clock_skew_daemon";
      StandardOutput="journal+console";
      Type = "simple";
    };
    wantedBy = ["multi-user.target"];
  };


  systemd.services.google-shutdown-scripts = {
    description = "Google Compute Engine Shutdown Scripts";
    after = [
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${gce}/bin/google_metadata_script_runner --script-type shutdown";
      RemainAfterExit = true;
      StandardOutput="journal+console";
      TimeoutStopSec = "0";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.google-startup-scripts = {
    description = "Google Compute Engine Startup Scripts";
    after = [
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_metadata_script_runner --script-type startup";
      KillMode = "process";
      StandardOutput = "journal+console";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.etc."sysctl.d/11-gce-network-security.conf".source = "${gce}/sysctl.d/11-gce-network-security.conf";
}
