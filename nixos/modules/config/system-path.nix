# This module defines the packages that appear in
# /run/current-system/sw.
{
  config,
  lib,
  pkgs,
  ...
}:
let

  corePackageNames = [
    "acl"
    "attr"
    "bashInteractive" # bash with ncurses support
    "bzip2"
    "coreutils-full"
    "cpio"
    "curl"
    "diffutils"
    "findutils"
    "gawk"
    "getent"
    "getconf"
    "gnugrep"
    "gnupatch"
    "gnused"
    "gnutar"
    "gzip"
    "xz"
    "less"
    "libcap"
    "ncurses"
    "netcat"
    "mkpasswd"
    "procps"
    "su"
    "time"
    "util-linux"
    "which"
    "zstd"
  ];
  corePackages =
    (map (
      n:
      let
        pkg = pkgs.${n};
      in
      lib.setPrio ((pkg.meta.priority or lib.meta.defaultPriority) + 3) pkg
    ) corePackageNames)
    ++ [ pkgs.stdenv.cc.libc ];
  corePackagesText = "[ ${lib.concatMapStringsSep " " (n: "pkgs.${n}") corePackageNames} ]";

  defaultPackageNames = [
    "perl"
    "rsync"
    "strace"
  ];
  defaultPackages = map (
    n:
    let
      pkg = pkgs.${n};
    in
    lib.setPrio ((pkg.meta.priority or lib.meta.defaultPriority) + 3) pkg
  ) defaultPackageNames;
  defaultPackagesText = "[ ${lib.concatMapStringsSep " " (n: "pkgs.${n}") defaultPackageNames} ]";

in

{
  options = {

    environment = {

      systemPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
        description = ''
          The set of packages that appear in
          /run/current-system/sw.  These packages are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.  (The latter is the main difference with
          installing them in the default profile,
          {file}`/nix/var/nix/profiles/default`.
        '';
      };

      corePackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        defaultText = lib.literalMD ''
          these packages, with their `meta.priority` numerically increased
          (thus lowering their installation priority):

              ${corePackagesText}
        '';
        example = [ ];
        description = ''
          Set of core packages for a normal interactive system.

          Only change this if you know what you're doing!

          Like with systemPackages, packages are installed to
          {file}`/run/current-system/sw`. They are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.
        '';
      };

      defaultPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = defaultPackages;
        defaultText = lib.literalMD ''
          these packages, with their `meta.priority` numerically increased
          (thus lowering their installation priority):

              ${defaultPackagesText}
        '';
        example = [ ];
        description = ''
          Set of default packages that aren't strictly necessary
          for a running system, entries can be removed for a more
          minimal NixOS installation.

          Like with systemPackages, packages are installed to
          {file}`/run/current-system/sw`. They are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.
        '';
      };

      pathsToLink = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        # Note: We need `/lib' to be among `pathsToLink' for NSS modules
        # to work.
        default = [ ];
        example = [ "/" ];
        description = "List of directories to be symlinked in {file}`/run/current-system/sw`.";
      };

      extraOutputsToInstall = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "dev"
          "info"
        ];
        description = ''
          Entries listed here will be appended to the `meta.outputsToInstall` attribute for each package in `environment.systemPackages`, and the files from the corresponding derivation outputs symlinked into {file}`/run/current-system/sw`.

          For example, this can be used to install the `dev` and `info` outputs for all packages in the system environment, if they are available.

          To use specific outputs instead of configuring them globally, select the corresponding attribute on the package derivation, e.g. `libxml2.dev` or `coreutils.info`.
        '';
      };

      extraSetup = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell fragments to be run after the system environment has been created. This should only be used for things that need to modify the internals of the environment, e.g. generating MIME caches. The environment being built can be accessed at $out.";
      };

    };

    system = {

      path = lib.mkOption {
        internal = true;
        description = ''
          The packages you want in the boot environment.
        '';
      };

    };

  };

  config = {

    # Set this here so that it has the right priority and allows ergonomic
    # merging.
    environment.corePackages = corePackages;

    environment.systemPackages = config.environment.corePackages ++ config.environment.defaultPackages;

    environment.pathsToLink = [
      "/bin"
      "/etc/xdg"
      "/etc/gtk-2.0"
      "/etc/gtk-3.0"
      "/lib" # FIXME: remove and update debug-info.nix
      "/sbin"
      "/share/emacs"
      "/share/hunspell"
      "/share/org"
      "/share/themes"
      "/share/vulkan"
      "/share/kservices5"
      "/share/kservicetypes5"
      "/share/kxmlgui5"
      "/share/systemd"
      "/share/thumbnailers"
    ];

    system.path = pkgs.buildEnv {
      name = "system-path";
      paths = config.environment.systemPackages;
      inherit (config.environment) pathsToLink extraOutputsToInstall;
      ignoreCollisions = true;
      # !!! Hacky, should modularise.
      # outputs TODO: note that the tools will often not be linked by default
      postBuild = ''
        # Remove wrapped binaries, they shouldn't be accessible via PATH.
        find $out/bin -maxdepth 1 -name ".*-wrapped" -type l -delete

        if [ -x $out/bin/glib-compile-schemas -a -w $out/share/glib-2.0/schemas ]; then
            $out/bin/glib-compile-schemas $out/share/glib-2.0/schemas
        fi

        ${config.environment.extraSetup}
      '';
    };

  };
}
