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
              qemu-img create -f raw $diskImage "4G"
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph = 
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create an empty filesysten and mount it.
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
                    
          # Amazon assumes that there is a /sbin/init, so create one.
          # Note that simply creating /sbin/init as a symlink breaks
          # some EC2 initrds (like Ubuntu's) because they do a "test
          # -x $mountPoint/sbin/init".
          mkdir -p /mnt/sbin
          echo "#! /nix/var/nix/profiles/system/init" > /mnt/sbin/init
          chmod +x /mnt/sbin/init

          umount /mnt
        ''
    );

  # On EC2 we don't get to supply our own kernel, so we can't load any
  # modules.  However, dhclient fails if the ipv6 module isn't loaded,
  # unless it's compiled without IPv6 support.  So do that.
  nixpkgs.config.packageOverrides = pkgsOld:                                        
    { dhcp = pkgs.lib.overrideDerivation pkgsOld.dhcp (oldAttrs:                    
        { configureFlags = "--disable-dhcpv6";                                      
        });                                                                         
    };                                                                              

  fileSystems =
    [ { mountPoint = "/";
        device = "/dev/disk/by-label/nixos";
      }
      { mountPoint = "/data";
        device = "/dev/sda2";
        autocreate = true;
      }
    ];

  swapDevices =
    [ { device = "/dev/sda3"; } ];

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

          echo "setting host name..."
          ${pkgs.nettools}/bin/hostname $(${pkgs.curl}/bin/curl http://169.254.169.254/1.0/meta-data/hostname)
        '';
    };
}
