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

  systemd.services.fetch-ssh-keys = {
    description = "Fetch host keys and authorized_keys for root user";

    wantedBy = [ "sshd.service" ];
    before = [ "sshd.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    script =
      let
        wget = "${pkgs.wget}/bin/wget --retry-connrefused -t 15 --waitretry=10 --header='Metadata-Flavor: Google'";
        mktemp = "mktemp --tmpdir=/run";
      in ''
        # When dealing with cryptographic keys, we want to keep things private.
        umask 077
        mkdir -m 0700 -p /root/.ssh

        echo "Obtaining SSH keys..."
        AUTH_KEYS=$(${mktemp})
        ${wget} -O $AUTH_KEYS http://metadata.google.internal/computeMetadata/v1/instance/attributes/sshKeys
        if [ -s $AUTH_KEYS ]; then
            # Read in key one by one, split in case Google decided
            # to append metadata (it does sometimes) and add to
            # authorized_keys if not already present.
            touch /root/.ssh/authorized_keys
            NEW_KEYS=$(${mktemp})
            # Yes this is a nix escape of two single quotes.
            while IFS=''' read -r line || [[ -n "$line" ]]; do
                keyLine=$(echo -n "$line" | cut -d ':' -f2)
                IFS=' ' read -r -a array <<< "$keyLine"
                if [ ''${#array[@]} -ge 3 ]; then
                    echo ''${array[@]:0:3} >> $NEW_KEYS
                    echo "Added ''${array[@]:2} to authorized_keys"
                fi
            done < $AUTH_KEYS
            mv $NEW_KEYS /root/.ssh/authorized_keys
            chmod 600 /root/.ssh/authorized_keys
            rm -f $KEY_PUB
        else
            echo "Downloading http://metadata.google.internal/computeMetadata/v1/project/attributes/sshKeys failed."
            false
        fi
        rm -f $AUTH_KEYS

        SSH_HOST_KEYS_DIR=$(${mktemp} -d)
        ${wget} -O $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh_host_ed25519_key
        ${wget} -O $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key.pub http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh_host_ed25519_key_pub
        if [ -s $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key -a -s $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key.pub ]; then
            mv -f $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key* /etc/ssh/
            chmod 600 /etc/ssh/ssh_host_ed25519_key
            chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
        else
            echo "Setup of ssh host keys from http://metadata.google.internal/computeMetadata/v1/instance/attributes/ failed."
            false
        fi
        rm -rf $SSH_HOST_KEYS_DIR
      '';
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    serviceConfig.StandardError = "journal+console";
    serviceConfig.StandardOutput = "journal+console";
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
    path = with pkgs; [ iproute ];
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
