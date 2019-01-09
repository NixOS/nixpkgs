{ config, lib, pkgs, ... }:
with lib;
let
  gce = pkgs.google-compute-engine;
  cfg = config.virtualisation.googleComputeImage;
in
{
  imports = [
    ../profiles/headless.nix
    ../profiles/qemu-guest.nix
  ];


  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
  };

  boot.growPartition = true;
  boot.kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
  boot.initrd.kernelModules = [ "virtio_scsi" ];
  boot.kernelModules = [ "virtio_pci" "virtio_net" ];

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
  services.openssh.passwordAuthentication = mkDefault false;

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

  security.googleOsLogin.enable = true;

  systemd.services.google-clock-skew-daemon = {
    description = "Google Compute Engine Clock Skew Daemon";
    after = [
      "network.target"
      "google-instance-setup.service"
      "google-network-setup.service"
    ];
    requires = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${gce}/bin/google_clock_skew_daemon --debug";
    };
  };

  systemd.services.google-instance-setup = {
    description = "Google Compute Engine Instance Setup";
    after = ["local-fs.target" "network-online.target" "network.target" "rsyslog.service"];
    before = ["sshd.service"];
    wants = ["local-fs.target" "network-online.target" "network.target"];
    wantedBy = [ "sshd.service" "multi-user.target" ];
    path = with pkgs; [ ethtool openssh ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_instance_setup --debug";
      Type = "oneshot";
    };
  };

  systemd.services.google-network-daemon = {
    description = "Google Compute Engine Network Daemon";
    after = ["local-fs.target" "network-online.target" "network.target" "rsyslog.service" "google-instance-setup.service"];
    wants = ["local-fs.target" "network-online.target" "network.target"];
    requires = ["network.target"];
    partOf = ["network.target"];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ iproute ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_network_daemon --debug";
    };
  };

  systemd.services.google-shutdown-scripts = {
    description = "Google Compute Engine Shutdown Scripts";
    after = [
      "local-fs.target"
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "systemd-resolved.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    wants = [ "local-fs.target" "network-online.target" "network.target"];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${gce}/bin/google_metadata_script_runner --debug --script-type shutdown";
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStopSec = "infinity";
    };
  };

  systemd.services.google-startup-scripts = {
    description = "Google Compute Engine Startup Scripts";
    after = [
      "local-fs.target"
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    wants = ["local-fs.target" "network-online.target" "network.target"];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_metadata_script_runner --debug --script-type startup";
      KillMode = "process";
      Type = "oneshot";
    };
  };


  # Settings taken from https://github.com/GoogleCloudPlatform/compute-image-packages/blob/master/google_config/sysctl/11-gce-network-security.conf
  boot.kernel.sysctl = {
    # Turn on SYN-flood protections.  Starting with 2.6.26, there is no loss
    # of TCP functionality/features under normal conditions.  When flood
    # protections kick in under high unanswered-SYN load, the system
    # should remain more stable, with a trade off of some loss of TCP
    # functionality/features (e.g. TCP Window scaling).
    "net.ipv4.tcp_syncookies" = mkDefault "1";

    # ignores source-routed packets
    "net.ipv4.conf.all.accept_source_route" = mkDefault "0";

    # ignores source-routed packets
    "net.ipv4.conf.default.accept_source_route" = mkDefault "0";

    # ignores ICMP redirects
    "net.ipv4.conf.all.accept_redirects" = mkDefault "0";

    # ignores ICMP redirects
    "net.ipv4.conf.default.accept_redirects" = mkDefault "0";

    # ignores ICMP redirects from non-GW hosts
    "net.ipv4.conf.all.secure_redirects" = mkDefault "1";

    # ignores ICMP redirects from non-GW hosts
    "net.ipv4.conf.default.secure_redirects" = mkDefault "1";

    # don't allow traffic between networks or act as a router
    "net.ipv4.ip_forward" = mkDefault "0";

    # don't allow traffic between networks or act as a router
    "net.ipv4.conf.all.send_redirects" = mkDefault "0";

    # don't allow traffic between networks or act as a router
    "net.ipv4.conf.default.send_redirects" = mkDefault "0";

    # reverse path filtering - IP spoofing protection
    "net.ipv4.conf.all.rp_filter" = mkDefault "1";

    # reverse path filtering - IP spoofing protection
    "net.ipv4.conf.default.rp_filter" = mkDefault "1";

    # ignores ICMP broadcasts to avoid participating in Smurf attacks
    "net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault "1";

    # ignores bad ICMP errors
    "net.ipv4.icmp_ignore_bogus_error_responses" = mkDefault "1";

    # logs spoofed, source-routed, and redirect packets
    "net.ipv4.conf.all.log_martians" = mkDefault "1";

    # log spoofed, source-routed, and redirect packets
    "net.ipv4.conf.default.log_martians" = mkDefault "1";

    # implements RFC 1337 fix
    "net.ipv4.tcp_rfc1337" = mkDefault "1";

    # randomizes addresses of mmap base, heap, stack and VDSO page
    "kernel.randomize_va_space" = mkDefault "2";

    # Reboot the machine soon after a kernel panic.
    "kernel.panic" = mkDefault "10";

    ## Not part of the original config

    # provides protection from ToCToU races
    "fs.protected_hardlinks" = mkDefault "1";

    # provides protection from ToCToU races
    "fs.protected_symlinks" = mkDefault "1";

    # makes locating kernel addresses more difficult
    "kernel.kptr_restrict" = mkDefault "1";

    # set ptrace protections
    "kernel.yama.ptrace_scope" = mkOverride 500 "1";

    # set perf only available to root
    "kernel.perf_event_paranoid" = mkDefault "2";

  };

}
