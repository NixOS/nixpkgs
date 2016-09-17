{ config, lib, pkgs, ... }:

with lib;
let
  diskSize = "20G";
in
{
  imports = [ ../profiles/headless.nix ../profiles/qemu-guest.nix ];

  system.build.brightboxImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "brightbox-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/$diskImageBase
              truncate $diskImage --size ${diskSize}
              mv closure xchg/
            '';

          postVM =
            ''
              PATH=$PATH:${lib.makeBinPath [ pkgs.gnutar pkgs.gzip ]}
              pushd $out
              ${pkgs.qemu_kvm}/bin/qemu-img convert -c -O qcow2 $diskImageBase nixos.qcow2
              rm $diskImageBase
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
          cp ${./brightbox-config.nix} /mnt/etc/nixos/configuration.nix

          # Generate the GRUB menu.
          ln -s vda /dev/sda
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt/proc /mnt/dev /mnt/sys
          umount /mnt
        ''
    );

  fileSystems."/".label = "nixos";

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "/dev/vda";
  boot.loader.timeout = 0;

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

  systemd.services."fetch-ec2-data" =
    { description = "Fetch EC2 Data";

      wantedBy = [ "multi-user.target" "sshd.service" ];
      before = [ "sshd.service" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      path = [ pkgs.wget pkgs.iproute ];

      script =
        ''
          wget="wget -q --retry-connrefused -O -"

          ${optionalString (config.networking.hostName == "") ''
            echo "setting host name..."
            ${pkgs.nettools}/bin/hostname $($wget http://169.254.169.254/latest/meta-data/hostname)
          ''}

          # Don't download the SSH key if it has already been injected
          # into the image (a Nova feature).
          if ! [ -e /root/.ssh/authorized_keys ]; then
              echo "obtaining SSH key..."
              mkdir -m 0700 -p /root/.ssh
              $wget http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > /root/key.pub
              if [ $? -eq 0 -a -e /root/key.pub ]; then
                  if ! grep -q -f /root/key.pub /root/.ssh/authorized_keys; then
                      cat /root/key.pub >> /root/.ssh/authorized_keys
                      echo "new key added to authorized_keys"
                  fi
                  chmod 600 /root/.ssh/authorized_keys
                  rm -f /root/key.pub
              fi
          fi

          # Extract the intended SSH host key for this machine from
          # the supplied user data, if available.  Otherwise sshd will
          # generate one normally.
          $wget http://169.254.169.254/2011-01-01/user-data > /root/user-data || true
          key="$(sed 's/|/\n/g; s/SSH_HOST_DSA_KEY://; t; d' /root/user-data)"
          key_pub="$(sed 's/SSH_HOST_DSA_KEY_PUB://; t; d' /root/user-data)"
          if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_dsa_key ]; then
              mkdir -m 0755 -p /etc/ssh
              (umask 077; echo "$key" > /etc/ssh/ssh_host_dsa_key)
              echo "$key_pub" > /etc/ssh/ssh_host_dsa_key.pub
          fi
        '';

      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
    };

}
