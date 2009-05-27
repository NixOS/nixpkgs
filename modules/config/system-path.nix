# This module defines the packages that appear in
# /var/run/current-system/sw.

{pkgs, config, ...}:

with pkgs.lib;

let

  # NixOS installation/updating tools.
  nixosTools = import ../../installer {
    inherit pkgs config;
  };

  
  systemPackages =
    [ config.system.sbin.modprobe # must take precedence over module_init_tools
      config.system.sbin.mount # must take precedence over util-linux
      config.environment.nix
      nixosTools.nixosInstall
      nixosTools.nixosRebuild
      nixosTools.nixosCheckout
      nixosTools.nixosHardwareScan
      nixosTools.nixosGenSeccureKeys
      pkgs.acl
      pkgs.attr
      pkgs.bashInteractive # bash with ncurses support
      pkgs.bzip2
      pkgs.coreutils
      pkgs.cpio
      pkgs.curl
      pkgs.e2fsprogs
      pkgs.findutils
      pkgs.glibc # for ldd, getent
      pkgs.glibcLocales
      pkgs.gnugrep
      pkgs.gnused
      pkgs.gnutar
      pkgs.grub
      pkgs.gzip
      pkgs.iputils
      pkgs.less
      pkgs.libcap
      pkgs.lvm2
      pkgs.man
      pkgs.mdadm
      pkgs.module_init_tools
      pkgs.nano
      pkgs.ncurses
      pkgs.netcat
      pkgs.nettools
      pkgs.ntp
      pkgs.openssh
      pkgs.pciutils
      pkgs.perl
      pkgs.procps
      pkgs.pwdutils
      pkgs.reiserfsprogs
      pkgs.rsync
      pkgs.seccure
      pkgs.strace
      pkgs.su
      pkgs.sysklogd
      pkgs.sysvtools
      pkgs.time
      pkgs.udev
      pkgs.upstart
      pkgs.usbutils
      pkgs.utillinux
      pkgs.wirelesstools
      (import ../../helpers/info-wrapper.nix {inherit (pkgs) bash texinfo writeScriptBin;})
    ]
    ++ pkgs.lib.optional config.services.bitlbee.enable pkgs.bitlbee
    ++ config.environment.extraPackages
    ++ pkgs.lib.optional config.fonts.enableFontDir config.system.build.x11Fonts

    # NSS modules need to be in `systemPath' so that (i) the builder
    # chroot gets to seem them, and (ii) applications can benefit from
    # changes in the list of NSS modules at run-time, without requiring
    # a reboot.
    ++ config.system.nssModules.list;

      
  options = {

    environment = {

      systemPackages = mkOption {
        default = systemPackages;
        description = ''
          The set of packages that appear in
          /var/run/current-system/sw.  These packages are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.  (The latter is the main difference with
          installing them in the default profile,
          <filename>/nix/var/nix/profiles/default</filename>.
        '';
      };

      # !!! Obsolete.
      extraPackages = mkOption {
        default = [];
        example = [pkgs.firefox pkgs.thunderbird];
        description = ''
          This option allows you to add additional packages to the system
          path.
        '';
      };

      pathsToLink = mkOption {
        default = ["/bin" "/sbin" "/lib" "/share/man" "/share/info" "/man" "/info"];
        example = ["/"];
        description = "
          Lists directories to be symlinked in `/var/run/current-system/sw'.
        ";
      };

    };

    system = {

      path = mkOption {
        default = config.environment.systemPackages;
        description = ''
          The packages you want in the boot environment.
        '';
        apply = list: pkgs.buildEnv {
          name = "system-path";
          paths = list;

          # Note: We need `/lib' to be among `pathsToLink' for NSS modules
          # to work.
          inherit (config.environment) pathsToLink;

          ignoreCollisions = true;
        };
      };

    };
      
  };


in

{
  require = [options];
}
