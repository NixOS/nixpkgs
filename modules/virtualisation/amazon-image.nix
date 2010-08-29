{ config, pkgs, ... }:

with pkgs.lib;

{
  system.build.amazonImage =
    pkgs.vmTools.runInLinuxVM (
      pkgs.runCommand "amazon-image"
        { preVM =
            ''
              mkdir $out
              diskImage=$out/nixos.img
              ${pkgs.vmTools.kvm}/bin/qemu-img create -f raw $diskImage "4G"
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph = 
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create an empty filesystem and mount it.
          ${pkgs.e2fsprogs}/sbin/mkfs.ext3 -L nixos /dev/vda
          ${pkgs.e2fsprogs}/sbin/tune2fs -c 0 -i 0 /dev/vda
          mkdir /mnt
          mount /dev/vda /mnt

          # The initrd expects these directories to exist.
          mkdir /mnt/dev /mnt/proc /mnt/sys

          # Copy all paths in the closure to the filesystem.
          storePaths=$(perl ${pkgs.pathsFromGraph} $ORIG_TMPDIR/closure)

          mkdir -p /mnt/nix/store
          cp -prvd $storePaths /mnt/nix/store/

          # Register the paths in the Nix database.
          printRegistration=1 perl ${pkgs.pathsFromGraph} $ORIG_TMPDIR/closure | \
              chroot /mnt ${config.environment.nix}/bin/nix-store --load-db

          # Create the system profile to allow nixos-rebuild to work.
          chroot /mnt ${config.environment.nix}/bin/nix-env \
              -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel}

          # `nixos-rebuild' requires an /etc/NIXOS.
          mkdir -p /mnt/etc
          touch /mnt/etc/NIXOS

          # Install a configuration.nix.
          mkdir -p /mnt/etc/nixos
          cp ${./amazon-config.nix} /mnt/etc/nixos/configuration.nix

          # Generate the GRUB menu.
          chroot /mnt ${config.system.build.toplevel}/bin/switch-to-configuration boot

          umount /mnt
        ''
    );

  fileSystems =
    [ { mountPoint = "/";
        device = "/dev/disk/by-label/nixos";
      }
      { mountPoint = "/ephemeral0";
        device = "/dev/xvdc";
        neededForBoot = true;
      }
    ];

  swapDevices =
    [ { device = "/dev/xvdb"; } ];

  boot.initrd.kernelModules = [ "xen-blkfront" ];
  boot.kernelModules = [ "xen-netfront" ];

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "nodev";
  boot.loader.grub.timeout = 0;
  boot.loader.grub.extraPerEntryConfig = "root (hd0)";

  # Put /tmp and /var on /ephemeral0, which has a lot more space.  
  # Unfortunately we can't do this with the `fileSystems' option 
  # because it has no support for creating the source of a bind 
  # mount.
  boot.initrd.postMountCommands =
    ''
      mkdir -m 1777 -p $targetRoot/ephemeral0/tmp
      mount --bind $targetRoot/ephemeral0/tmp $targetRoot/tmp
      mkdir -m 755 -p $targetRoot/ephemeral0/var
      mount --bind $targetRoot/ephemeral0/var $targetRoot/var
    '';

  # There are no virtual consoles.
  services.mingetty.ttys = [ ];

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";

  # Obtain the SSH key and host name at startup time.
  jobs.fetchEC2Data =
    { name = "fetch-ec2-data";

      startOn = "ip-up";

      task = true;

      script =
        ''
          echo "obtaining SSH key..."
          mkdir -p /root/.ssh
          ${pkgs.curl}/bin/curl --retry 3 --retry-delay 0 --fail \
            -o /root/key.pub \
            http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
          if [ $? -eq 0 -a -e /root/key.pub ]; then
              if ! grep -q -f /root/key.pub /root/.ssh/authorized_keys; then
                  cat /root/key.pub >> /root/.ssh/authorized_keys
                  echo "new key added to authorized_keys"
              fi
              chmod 600 /root/.ssh/authorized_keys
              rm -f /root/key.pub
          fi

          # Print the host public key on the console so that the user
          # can obtain it securely by parsing the output of
          # ec2-get-console-output.
          echo "-----BEGIN SSH HOST KEY FINGERPRINTS-----" > /dev/console
          ${pkgs.openssh}/bin/ssh-keygen -l -f /etc/ssh/ssh_host_dsa_key.pub > /dev/console
          echo "-----END SSH HOST KEY FINGERPRINTS-----" > /dev/console

          echo "setting host name..."
          ${pkgs.nettools}/bin/hostname $(${pkgs.curl}/bin/curl http://169.254.169.254/1.0/meta-data/hostname)
        '';
    };
}
