# This module defines the packages that appear in
# /run/current-system/sw.

{ config, lib, pkgs, ... }:

with lib;

let
  # This type can accept three different types of expressions:
  #   * A list of packages like `[ pkgs.foo pkgs.bar ]`
  #   * An attribute set of packages like `{ inherit (pkgs) foo bar; }`
  #   * A more structured attribute set of packages like `{ "foo".package = pkgs.foo.override { hasBar = false; }; }`
  #
  # The first two cases will be coerced into the third one, which allows the
  # package to be disabled and its package and list of outputs to be overridden.
  packagesType =
    let
      inherit (lib) types;

      outputsFor' = drv: lib.listToAttrs (
        map
          (output: lib.nameValuePair output ({
            enable = true;
          } // lib.optionalAttrs (output ? meta.priority) {
            inherit (meta.output) priority;
          }))
          (lib.outputsFor drv)
      );

      drvToAttrs = drv: {
        package = lib.defaultOutput drv;
        outputs = outputsFor' drv;
      };

      pkgsToAttrs = list:
        lib.mapAttrs
          (name: values:
            if length values == 0 then
              abort "Something went terribly wrong"
            else {
              # If we get multiple values here, it means that we got the same
              # derivation multiple times.
              # This is usually because different outputs were selected.
              # Therefore we add the derivation once and collect all the selected outputs.
              package = defaultOutput (head values);
              outputs = lib.foldl (acc: drv: acc // outputsFor' drv) {} values;
            }
          )
          (lib.groupBy (drv: builtins.unsafeDiscardStringContext drv.drvPath) list);
    in
    types.coercedTo
      (types.listOf types.package)
      pkgsToAttrs
      (types.attrsOf (types.coercedTo
        types.package
        drvToAttrs
        (types.submodule ( { config, lib, ... }: {
          options = {
            enable = (lib.mkEnableOption "the package") // {
              default = true;
            };
            package = lib.mkOption {
              # We can get the same derivation here if it was added with different
              # outputs selected. In that case we want to merge the values if the
              # outpath is the same, and concat the lists of outputs.
              type = types.packageByOutPath;
              description = "The derivation that will be used for this package.";
            };
            outputs =
              let
                # config gets shadowed below, so we assign it another name here
                # to be able to access it still.
                outerConfig = config;
              in
              lib.mkOption {
                type = types.attrsOf (types.submodule ( { name, config, lib, ... }: {
                  options = {
                    enable = lib.mkEnableOption "the output" // {
                      default = true;
                    };
                    name = lib.mkOption {
                      type = types.str;
                      default = name;
                      description = "The name of this output.";
                    };
                    priority = lib.mkOption {
                      type = types.nullOr (types.int // {
                        # If an output gets selected twice with different priorities,
                        # we want to retain the lower priority since nix-env
                        # considers lower numerical values to indicate higher priority.
                        # See https://nixos.org/manual/nix/stable/command-ref/nix-env/install.html
                        merge = loc: defs:
                          if defs == [] then abort "This case should never happen."
                          else if length defs == 1 then (head defs).value
                          else
                            lib.foldl' (sum: el: lib.min sum el.value) (head defs).value (tail defs);
                      });
                      default = outerConfig.package.${name}.meta.priority or null;
                      defaultText = ''
                        The meta.priority value of the package, or null if there is no priority assigned.
                      '';
                      description = "The nix-env priority for this output.";
                    };
                  };
                }));
                default = outputsFor' config.package;
                defaultText = ''
                  The default outputs for the package, as defined by lib.outputsFor.
                '';
                description = "The outputs to install for this package.";
              };
          };
        }))
      ));

  # This function takes the attribute set from the packages type and converts it
  # back into a list that can be given to something like pkgs.buildEnv.
  packagesApplyFun = ps:
    let
      enabled = lib.filterAttrs (_: p: p.enable) ps;
      setOutputs = p:
        let
          # Sentinel value in case the priority is null, used as an attrset key
          none = "none";

          priorityToString = prio: if prio == null then none else toString prio;

          # Construct an attrset mapping priorities to the outputs of the current
          # package that need to be installed with that priority.
          # So the result is something like:
          # {
          #   "5" = [ "out" "man" ];
          #   "8" = [ "lib" ];
          # }
          outputsToInstall =
            let
              addOutput = acc: output: {
                ${priorityToString output.priority} =
                  (acc.${priorityToString output.priority} or [ ]) ++ [
                    output.name
                  ];
              };
              in lib.foldlAttrs (acc: _: output: addOutput acc output) { } (
                lib.filterAttrs (_: output: output.enable) p.outputs
              );

          # Set the priority of the drv to the given priority.
          # If the given priority is the string "none", then we do nothing.
          maybeSetPriority = maybePrio: drv:
            if maybePrio == none
            then drv
            else lib.setPrioRecursively (lib.toInt maybePrio) drv;
        in
        # Go over the attrset mapping priorities to outputs.
        # We create an entry in the list for every priority, setting the priority
        # of the derivation to the given value, and setting the outputsToInstall
        # to the outputs for that priority.
        lib.mapAttrsToList
          (priority: outputs:
            maybeSetPriority
              priority
              (lib.setOutputsToInstall p.package outputs)
          )
          outputsToInstall;
    in
    # For every enabled package, call setOutputs, and concat everything together.
    lib.concatLists (lib.mapAttrsToList (_: setOutputs) enabled);

  requiredPackages = mapAttrs (name: pkg: setPrioRecursively ((pkg.meta.priority or 5) + 3) pkg)
    {
      inherit (pkgs)
        acl
        attr
        bashInteractive # bash with ncurses support
        bzip2
        coreutils-full
        cpio
        curl
        diffutils
        findutils
        gawk
        getent
        getconf
        gnugrep
        gnupatch
        gnused
        gnutar
        gzip
        xz
        less
        libcap
        ncurses
        netcat
        mkpasswd
        procps
        su
        time
        util-linux
        which
        zstd;
      inherit (pkgs.stdenv.cc) libc;
      ssh = config.programs.ssh.package;
    };

  defaultPackageNames =
    [ "perl"
      "rsync"
      "strace"
    ];
  defaultPackages =
    lib.listToAttrs (map
      (n: let pkg = pkgs.${n}; in lib.nameValuePair n (setPrioRecursively ((pkg.meta.priority or 5) + 3) pkg))
      defaultPackageNames);
  defaultPackagesText = "[ ${concatMapStringsSep " " (n: "pkgs.${n}") defaultPackageNames } ]";

in

{
  options = {

    environment = {

      systemPackages = mkOption {
        type = packagesType;
        apply = packagesApplyFun;
        default = {};
        example = literalExpression "{ inherit (pkgs) firefox thunderbird; }";
        description = lib.mdDoc ''
          The set of packages that appear in
          /run/current-system/sw.  These packages are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.  (The latter is the main difference with
          installing them in the default profile,
          {file}`/nix/var/nix/profiles/default`.

          This option accepts three different types of expressions:
          - An attribute set of packages like `{ inherit (pkgs) foo bar; }`
          - A more structured attribute set of packages like
            ```
            {
              foo = {
                package = pkgs.foo.override { hasBar = false; };
                outputs = { out = true; lib = true; };
              };
            }
            ```
          - A list of packages like `[ pkgs.foo pkgs.bar ]` (this is deprecated)

          The first and third of which will be converted into the second form.

          The recommended syntax to add packages to this set, is to write
          `{ inherit (pkgs) foo; }`.
          To disable or override a package that was added elsewhere, you can do
          `{ foo.enable = false; }` or `{ foo = pkgs.foo.override { ... }; }`.
        '';
      };

      defaultPackages = mkOption {
        type = packagesType;
        apply = packagesApplyFun;
        default = defaultPackages;
        defaultText = literalMD ''
          these packages, with their `meta.priority` numerically increased
          (thus lowering their installation priority):

              ${defaultPackagesText}
        '';
        example = {};
        description = lib.mdDoc ''
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

      pathsToLink = mkOption {
        type = types.listOf types.str;
        # Note: We need `/lib' to be among `pathsToLink' for NSS modules
        # to work.
        default = [];
        example = ["/"];
        description = lib.mdDoc "List of directories to be symlinked in {file}`/run/current-system/sw`.";
      };

      extraOutputsToInstall = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "dev" "info" ];
        description = lib.mdDoc ''
          Entries listed here will be appended to the `meta.outputsToInstall` attribute for each package in `environment.systemPackages`, and the files from the corresponding derivation outputs symlinked into {file}`/run/current-system/sw`.

          For example, this can be used to install the `dev` and `info` outputs for all packages in the system environment, if they are available.

          To use specific outputs instead of configuring them globally, select the corresponding attribute on the package derivation, e.g. `libxml2.dev` or `coreutils.info`.
        '';
      };

      extraSetup = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Shell fragments to be run after the system environment has been created. This should only be used for things that need to modify the internals of the environment, e.g. generating MIME caches. The environment being built can be accessed at $out.";
      };

    };

    system = {

      path = mkOption {
        internal = true;
        description = lib.mdDoc ''
          The packages you want in the boot environment.
        '';
      };

    };

  };

  config = {

    environment.systemPackages = lib.mkMerge [
      requiredPackages
      config.environment.defaultPackages
    ];

    environment.pathsToLink =
      [ "/bin"
        "/etc/xdg"
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

    system.path = pkgs.buildEnv {
      name = "system-path";
      paths = config.environment.systemPackages;
      inherit (config.environment) pathsToLink extraOutputsToInstall;
      ignoreCollisions = true;
      # !!! Hacky, should modularise.
      # outputs TODO: note that the tools will often not be linked by default
      postBuild =
        ''
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
