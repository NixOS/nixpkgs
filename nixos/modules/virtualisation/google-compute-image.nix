{ config, lib, pkgs, ... }:

with lib;
let
  diskSize = 1024; # MB
in
{
  imports = [ ../profiles/headless.nix ../profiles/qemu-guest.nix ./grow-partition.nix ];

  # https://cloud.google.com/compute/docs/tutorials/building-images
  networking.firewall.enable = mkDefault false;

  system.build.googleComputeImage = import ../../lib/make-disk-image.nix {
    name = "google-compute-image";
    postVM = ''
      PATH=$PATH:${pkgs.stdenv.lib.makeBinPath [ pkgs.gnutar pkgs.gzip ]}
      pushd $out
      mv $diskImage disk.raw
      tar -Szcf nixos-image-${config.system.nixosLabel}-${pkgs.stdenv.system}.raw.tar.gz disk.raw
      rm $out/disk.raw
      popd
    '';
    configFile = <nixpkgs/nixos/modules/virtualisation/google-compute-config.nix>;
    format = "raw";
    inherit diskSize;
    inherit config lib pkgs;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
  };

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

  # Force getting the hostname from Google Compute.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  # Configure default metadata hostnames
  networking.extraHosts = ''
    169.254.169.254 metadata.google.internal metadata
  '';

  networking.timeServers = [ "metadata.google.internal" ];

  networking.usePredictableInterfaceNames = false;

  systemd.services.fetch-ssh-keys =
    { description = "Fetch host keys and authorized_keys for root user";

      wantedBy = [ "sshd.service" ];
      before = [ "sshd.service" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      script = let wget = "${pkgs.wget}/bin/wget --retry-connrefused -t 15 --waitretry=10 --header='Metadata-Flavor: Google'";
                   mktemp = "mktemp --tmpdir=/run"; in
        ''
          # When dealing with cryptographic keys, we want to keep things private.
          umask 077
          # Don't download the SSH key if it has already been downloaded
          echo "Obtaining SSH keys..."
          mkdir -m 0700 -p /root/.ssh
          AUTH_KEYS=$(${mktemp})
          ${wget} -O $AUTH_KEYS http://metadata.google.internal/computeMetadata/v1/project/attributes/sshKeys
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
        '';
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.StandardError = "journal+console";
      serviceConfig.StandardOutput = "journal+console";
    };

  # Setings taken from https://cloud.google.com/compute/docs/tutorials/building-images#providedkernel
  boot.kernel.sysctl = {
    # enables syn flood protection
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
