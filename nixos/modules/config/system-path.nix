# This module defines the packages that appear in
# /run/current-system/sw.

{ config, lib, pkgs, ... }:

with lib;

let

  extraManpages = pkgs.runCommand "extra-manpages" { buildInputs = [ pkgs.help2man ]; }
    ''
      mkdir -p $out/share/man/man1
      help2man ${pkgs.gnutar}/bin/tar > $out/share/man/man1/tar.1
    '';

  requiredPackages =
    [ config.nix.package
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
      pkgs.xz
      pkgs.less
      pkgs.libcap
      pkgs.man
      pkgs.nano
      pkgs.ncurses
      pkgs.netcat
      pkgs.openssh
      pkgs.pciutils
      pkgs.perl
      pkgs.procps
      pkgs.rsync
      pkgs.strace
      pkgs.sysvtools
      pkgs.su
      pkgs.time
      pkgs.usbutils
      pkgs.utillinux
      extraManpages
    ];

in

{
  options = {

    environment = {

      systemPackages = mkOption {
        type = types.listOf types.path;
        default = [];
        example = "[ pkgs.firefox pkgs.thunderbird ]";
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
        type = types.listOf types.str;
        # Note: We need `/lib' to be among `pathsToLink' for NSS modules
        # to work.
        default = [];
        example = ["/"];
        description = "List of directories to be symlinked in `/run/current-system/sw'.";
      };
    };

    system = {

      path = mkOption {
        internal = true;
        description = ''
          The packages you want in the boot environment.
        '';
      };

    };

  };

  config = {

    environment.systemPackages = requiredPackages;

    environment.pathsToLink =
      [ "/bin"
        "/etc/xdg"
        "/info"
        "/lib"
        "/man"
        "/sbin"
        "/share/emacs"
        "/share/vim-plugins"
        "/share/org"
        "/share/info"
        "/share/terminfo"
        "/share/man"
      ];

    system.path = pkgs.buildEnv {
      name = "system-path";
      paths = config.environment.systemPackages;
      inherit (config.environment) pathsToLink;
      ignoreCollisions = true;
      # !!! Hacky, should modularise.
      postBuild =
        ''
          if [ -x $out/bin/update-mime-database -a -w $out/share/mime/packages ]; then
              XDG_DATA_DIRS=$out/share $out/bin/update-mime-database -V $out/share/mime > /dev/null
          fi

          if [ -x $out/bin/gtk-update-icon-cache -a -f $out/share/icons/hicolor/index.theme ]; then
              $out/bin/gtk-update-icon-cache $out/share/icons/hicolor
          fi

          if [ -x $out/bin/glib-compile-schemas -a -w $out/share/glib-2.0/schemas ]; then
              $out/bin/glib-compile-schemas $out/share/glib-2.0/schemas
          fi

          if [ -x $out/bin/update-desktop-database -a -w $out/share/applications ]; then
              $out/bin/update-desktop-database $out/share/applications
          fi
        '';
    };

  };
}
