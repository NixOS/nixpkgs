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
              qemu-img create -f raw $diskImage "1024M"
            '';
          buildInputs = [ pkgs.utillinux pkgs.perl ];
          exportReferencesGraph = 
            [ "closure" config.system.build.toplevel ];
        }
        ''
          # Create an empty filesysten and mount it.
          ${pkgs.e2fsprogs}/sbin/mkfs.ext3 /dev/vda
          mkdir /mnt
          mount /dev/vda /mnt

          # Copy all paths in the closure to the filesystem.
          storePaths=$(perl ${pkgs.pathsFromGraph} $ORIG_TMPDIR/closure)

          mkdir -p /mnt/nix/store
          cp -prvd $storePaths /mnt/nix/store/

          # Amazon assumes that there is a /sbin/init, so symlink it
          # to the stage 2 init script.  Since we cannot set the path
          # to the system configuration via the systemConfig kernel
          # parameter, use a /system symlink.
          mkdir -p /mnt/sbin
          ln -s ${config.system.build.bootStage2} /mnt/sbin/init
          ln -s ${config.system.build.toplevel} /mnt/system

          set -x
          sync
          umount /mnt
          sync
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

  # The root filesystem is mounted by Amazon's kernel/initrd.
  fileSystems = [ ];

  swapDevices =
    [ { device = "/dev/sda2"; } ];

  # There are no virtual consoles.
  services.mingetty.ttys = [ ];

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.sshd.enable = true;
  #services.sshd.permitRootLogin = "without-password";

  boot.postBootCommands =
    ''
      echo xyzzy_foobar | ${pkgs.pwdutils}/bin/passwd --stdin
    '';

  # Obtain the SSH key at startup time.
  /*
  jobs.fetchSSHKey =
    { name = "fetch-ssh-key";

      startOn = "ip-up";

      task = true;

      script =
        ''
          set -x
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
        '';
    };
  */
}
