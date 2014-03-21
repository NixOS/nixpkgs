{ config, pkgs, ... }:

with pkgs.lib;
let
  diskSize = "100G";
in
{
  imports = [ ../profiles/headless.nix ../profiles/qemu-guest.nix ];

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
              PATH=$PATH:${pkgs.gnutar}/bin:${pkgs.gzip}/bin
              pushd $out
              mv $diskImageBase disk.raw
              tar -Szcf $diskImageBase.tar.gz disk.raw
              rm $out/disk.raw
              popd
            '';
          diskImageBase = "nixos-${config.system.nixosVersion}-${pkgs.stdenv.system}.raw";
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
              chroot /mnt ${config.nix.package}/bin/nix-store --load-db

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.nix.package}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

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

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";

  # Force getting the hostname from Google Compute.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  # Prevent logging in as root without a password.  This doesn't really matter,
  # since the only PAM services that allow logging in with a null
  # password are local ones that are inaccessible on Google Compute machines.
  security.initialRootPassword = mkDefault "!";

  # Configure default metadata hostnames
  networking.extraHosts = ''
    169.254.169.254 metadata.google.internal metadata
  '';

  systemd.services.fetch-root-authorized-keys =
    { description = "Fetch authorized_keys for root user";

      wantedBy = [ "multi-user.target" ];
      before = [ "sshd.service" ];
      after = [ "network.target" ];

      path  = [ pkgs.curl ];
      script =
        ''
          # Don't download the SSH key if it has already been downloaded
          if ! [ -e /root/.ssh/authorized_keys ]; then
                echo "obtaining SSH key..."
                mkdir -p /root/.ssh
                curl -o /root/authorized-keys-metadata http://metadata/0.1/meta-data/authorized-keys
                if [ $? -eq 0 -a -e /root/authorized-keys-metadata ]; then
                    cat /root/authorized-keys-metadata | cut -d: -f2- > /root/key.pub
                    if ! grep -q -f /root/key.pub /root/.ssh/authorized_keys; then
                        cat /root/key.pub >> /root/.ssh/authorized_keys
                        echo "new key added to authorized_keys"
                    fi
                    chmod 600 /root/.ssh/authorized_keys
                    rm -f /root/key.pub /root/authorized-keys-metadata
                fi
          fi
        '';
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
     };


}
