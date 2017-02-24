{ config, lib, pkgs, ... }:

with lib;
let
  diskSize = "100G";
in
{
  imports = [ ../profiles/headless.nix ../profiles/qemu-guest.nix ];

  # https://cloud.google.com/compute/docs/tutorials/building-images
  networking.firewall.enable = mkDefault false;

  system.build.googleComputeImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "google-compute-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/$diskImageBase
              truncate $diskImage --size ${diskSize}
              mv closure xchg/
            '';

          postVM =
            ''
              PATH=$PATH:${pkgs.stdenv.lib.makeBinPath [ pkgs.gnutar pkgs.gzip ]}
              pushd $out
              mv $diskImageBase disk.raw
              tar -Szcf $diskImageBase.tar.gz disk.raw
              rm $out/disk.raw
              popd
            '';
          diskImageBase = "nixos-image-${config.system.nixosLabel}-${pkgs.stdenv.system}.raw";
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph =
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create partition table
          ${pkgs.parted}/sbin/parted /dev/vda mklabel msdos
          ${pkgs.parted}/sbin/parted /dev/vda mkpart primary ext4 1 ${diskSize}
          ${pkgs.parted}/sbin/parted /dev/vda print
          . /sys/class/block/vda1/uevent
          mknod /dev/vda1 b $MAJOR $MINOR

          # Create an empty filesystem and mount it.
          ${pkgs.e2fsprogs}/sbin/mkfs.ext4 -L nixos /dev/vda1
          ${pkgs.e2fsprogs}/sbin/tune2fs -c 0 -i 0 /dev/vda1

          mkdir /mnt
          mount /dev/vda1 /mnt

          # The initrd expects these directories to exist.
          mkdir /mnt/dev /mnt/proc /mnt/sys

          mount --bind /proc /mnt/proc
          mount --bind /dev /mnt/dev
          mount --bind /sys /mnt/sys

          # Copy all paths in the closure to the filesystem.
          storePaths=$(perl ${pkgs.pathsFromGraph} /tmp/xchg/closure)

          mkdir -p /mnt/nix/store
          echo "copying everything (will take a while)..."
          cp -prd $storePaths /mnt/nix/store/

          # Register the paths in the Nix database.
          printRegistration=1 perl ${pkgs.pathsFromGraph} /tmp/xchg/closure | \
              chroot /mnt ${config.nix.package.out}/bin/nix-store --load-db --option build-users-group ""

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package.out}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel} \
              --option build-users-group ""

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          # `switch-to-configuration' requires a /bin/sh
          mkdir -p /mnt/bin
          ln -s ${config.system.build.binsh}/bin/sh /mnt/bin/sh

          # Install a configuration.nix.
          mkdir -p /mnt/etc/nixos /mnt/boot/grub
          cp ${./google-compute-config.nix} /mnt/etc/nixos/configuration.nix

          # Generate the GRUB menu.
          ln -s vda /dev/sda
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  fileSystems."/".label = "nixos";

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
          if ! [ -s /root/.ssh/authorized_keys ]; then
              echo "obtaining SSH key..."
              mkdir -m 0700 -p /root/.ssh
              AUTH_KEYS=$(${mktemp})
              ${wget} -O $AUTH_KEYS http://metadata.google.internal/0.1/meta-data/authorized-keys
              if [ -s $AUTH_KEYS ]; then
                  KEY_PUB=$(${mktemp})
                  cat $AUTH_KEYS | cut -d: -f2- > $KEY_PUB
                  if ! grep -q -f $KEY_PUB /root/.ssh/authorized_keys; then
                      cat $KEY_PUB >> /root/.ssh/authorized_keys
                      echo "New key added to authorized_keys."
                  fi
                  chmod 600 /root/.ssh/authorized_keys
                  rm -f $KEY_PUB
              else
                  echo "Downloading http://metadata.google.internal/0.1/meta-data/authorized-keys failed."
                  false
              fi
              rm -f $AUTH_KEYS
          fi

          countKeys=0
          ${flip concatMapStrings config.services.openssh.hostKeys (k :
            let kName = baseNameOf k.path; in ''
              PRIV_KEY=$(${mktemp})
              echo "trying to obtain SSH private host key ${kName}"
              ${wget} -O $PRIV_KEY http://metadata.google.internal/0.1/meta-data/attributes/${kName} && :
              if [ $? -eq 0 -a -s $PRIV_KEY ]; then
                  countKeys=$((countKeys+1))
                  mv -f $PRIV_KEY ${k.path}
                  echo "Downloaded ${k.path}"
                  chmod 600 ${k.path}
                  ${config.programs.ssh.package}/bin/ssh-keygen -y -f ${k.path} > ${k.path}.pub
                  chmod 644 ${k.path}.pub
              else
                  echo "Downloading http://metadata.google.internal/0.1/meta-data/attributes/${kName} failed."
              fi
              rm -f $PRIV_KEY
            ''
          )}

          if [[ $countKeys -le 0 ]]; then
             echo "failed to obtain any SSH private host keys."
             false
          fi
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
    "kernel.yama.ptrace_scope" = mkDefault "1";

    # set perf only available to root
    "kernel.perf_event_paranoid" = mkDefault "2";

  };

}
