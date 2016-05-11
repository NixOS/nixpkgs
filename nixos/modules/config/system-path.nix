# This module defines the packages that appear in
# /run/current-system/sw.

{ config, lib, pkgs, ... }:

with lib;

let

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
      pkgs.nano
      pkgs.ncurses
      pkgs.netcat
      config.programs.ssh.package
      pkgs.perl
      pkgs.procps
      pkgs.rsync
      pkgs.strace
      pkgs.su
      pkgs.time
      pkgs.texinfoInteractive
      pkgs.utillinux
      pkgs.which # 88K size
    ];

in

{
  options = {

    environment = {

      systemPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.firefox pkgs.thunderbird ]";
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
        description = "List of directories to be symlinked in <filename>/run/current-system/sw</filename>.";
      };

      extraOutputsToInstall = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "doc" "info" "docdev" ];
        description = "List of additional package outputs to be symlinked into <filename>/run/current-system/sw</filename>.";
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
        "/lib" # FIXME: remove and update debug-info.nix
        "/sbin"
        "/share/applications"
        "/share/desktop-directories"
        "/share/doc"
        "/share/emacs"
        "/share/icons"
        "/share/info"
        "/share/menus"
        "/share/mime"
        "/share/nano"
        "/share/org"
        "/share/terminfo"
        "/share/themes"
        "/share/vim-plugins"
      ];

    system.path = pkgs.buildEnv {
      name = "system-path";
      paths = config.environment.systemPackages;
      inherit (config.environment) pathsToLink extraOutputsToInstall;
      ignoreCollisions = true;
      # !!! Hacky, should modularise.
      # outputs TODO: note that the tools will often not be linked by default
      postBuild =
        ''
          if [ -x $out/bin/update-mime-database -a -w $out/share/mime ]; then
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

          if [ -x $out/bin/install-info -a -w $out/share/info ]; then
            shopt -s nullglob
            for i in $out/share/info/*.info $out/share/info/*.info.gz; do
                $out/bin/install-info $i $out/share/info/dir
            done
          fi
        '';
    };

  };
}
