# This module defines the packages that appear in
# /run/current-system/sw.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.environment;

  extraManpages = pkgs.runCommand "extra-manpages" { buildInputs = [ pkgs.help2man ]; }
    ''
      mkdir -p $out/share/man/man1
      help2man ${pkgs.gnutar}/bin/tar > $out/share/man/man1/tar.1
    '';

  requiredPackages =
    [ config.environment.nix
      pkgs.acl
      pkgs.attr
      pkgs.bashInteractive # bash with ncurses support
      pkgs.bzip2
      pkgs.coreutils
      pkgs.cpio
      pkgs.curl
      pkgs.diffutils
      pkgs.eject # HAL depends on it anyway
      pkgs.findutils
      pkgs.gawk
      pkgs.glibc # for ldd, getent
      pkgs.gnugrep
      pkgs.gnupatch
      pkgs.gnused
      pkgs.gnutar
      pkgs.gzip
      pkgs.less
      pkgs.libcap
      pkgs.man
      pkgs.nano
      pkgs.ncurses
      pkgs.netcat
      pkgs.ntp
      pkgs.openssh
      pkgs.pciutils
      pkgs.perl
      pkgs.procps
      pkgs.rsync
      pkgs.strace
      pkgs.sysvtools
      pkgs.time
      pkgs.usbutils
      pkgs.utillinux
      extraManpages      
    ];


  options = {

    environment = {

      systemPackages = mkOption {
        default = [];
        example = "[ pkgs.icecat3 pkgs.thunderbird ]";
        description = ''
          The set of packages that appear in
          /run/current-system/sw.  These packages are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.  (The latter is the main difference with
          installing them in the default profile,
          <filename>/nix/var/nix/profiles/default</filename>.
        '';
      };

      pathsToLink = mkOption {
        # Note: We need `/lib' to be among `pathsToLink' for NSS modules
        # to work.
        default = [];
        example = ["/"];
        description = "
          Lists directories to be symlinked in `/run/current-system/sw'.
        ";
      };
    };

    system = {

      path = mkOption {
        default = cfg.systemPackages;
        description = ''
          The packages you want in the boot environment.
        '';

        apply = list: pkgs.buildEnv {
          name = "system-path";
          paths = list;
          inherit (cfg) pathsToLink;
          ignoreCollisions = true;
          # !!! Hacky, should modularise.
          postBuild =
            ''
              if [ -x $out/bin/update-mime-database -a -w $out/share/mime/packages ]; then
                  $out/bin/update-mime-database -V $out/share/mime
              fi

              if [ -x $out/bin/gtk-update-icon-cache -a -f $out/share/icons/hicolor/index.theme ]; then
                  $out/bin/gtk-update-icon-cache $out/share/icons/hicolor
              fi
            '';
        };

      };

    };

  };


in

{
  require = [ options ];

  environment.systemPackages = requiredPackages;
  environment.pathsToLink = [
    "/bin"
    "/etc/xdg"
    "/info"
    "/lib"
    "/man"
    "/sbin"
    "/share/emacs"
    "/share/org"
    "/share/info"
    "/share/terminfo"
    "/share/man"
  ];
}
