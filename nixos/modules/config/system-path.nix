# This module defines the packages that appear in
# /run/current-system/sw.

{ config, lib, pkgs, ... }:

with lib;

let

  requiredPackages = map (pkg: setPrio ((pkg.meta.priority or 5) + 3) pkg)
    [ pkgs.acl
      pkgs.attr
      pkgs.bashInteractive # bash with ncurses support
      pkgs.bzip2
      pkgs.coreutils-full
      pkgs.cpio
      pkgs.curl
      pkgs.diffutils
      pkgs.findutils
      pkgs.gawk
      pkgs.stdenv.cc.libc
      pkgs.getent
      pkgs.getconf
      pkgs.gnugrep
      pkgs.gnupatch
      pkgs.gnused
      pkgs.gnutar
      pkgs.gzip
      pkgs.xz
      pkgs.less
      pkgs.libcap
      pkgs.ncurses
      pkgs.netcat
      config.programs.ssh.package
      pkgs.mkpasswd
      pkgs.procps
      pkgs.su
      pkgs.time
      pkgs.util-linux
      pkgs.which
      pkgs.zstd
    ];

    defaultPackages = map (pkg: setPrio ((pkg.meta.priority or 5) + 3) pkg)
      [ pkgs.nano
        pkgs.perl
        pkgs.rsync
        pkgs.strace
      ];

in

{
  imports = [ ./system-path-core.nix ];

  options = {

    environment = {

      defaultPackages = mkOption {
        type = types.listOf types.package;
        default = defaultPackages;
        example = [];
        description = ''
          Set of default packages that aren't strictly necessary
          for a running system, entries can be removed for a more
          minimal NixOS installation.

          Note: If <package>pkgs.nano</package> is removed from this list,
          make sure another editor is installed and the
          <literal>EDITOR</literal> environment variable is set to it.
          Environment variables can be set using
          <option>environment.variables</option>.

          Like with systemPackages, packages are installed to
          <filename>/run/current-system/sw</filename>. They are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.
        '';
      };

    };

  };

  config = {

    environment.systemPackages = requiredPackages ++ config.environment.defaultPackages;

    environment.pathsToLink =
      [ "/etc/xdg"
        "/etc/gtk-2.0"
        "/etc/gtk-3.0"
        "/lib" # FIXME: remove and update debug-info.nix
        "/sbin"
        "/share/emacs"
        "/share/hunspell"
        "/share/nano"
        "/share/org"
        "/share/themes"
        "/share/vim-plugins"
        "/share/vulkan"
        "/share/kservices5"
        "/share/kservicetypes5"
        "/share/kxmlgui5"
        "/share/systemd"
        "/share/thumbnailers"
      ];

    environment.extraSetup = ''
      if [ -x $out/bin/glib-compile-schemas -a -w $out/share/glib-2.0/schemas ]; then
          $out/bin/glib-compile-schemas $out/share/glib-2.0/schemas
      fi
    '';

  };
}
