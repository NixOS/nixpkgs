{ config, lib, pkgs, ... }:

with lib;

let
  systemBuilder =
    ''
      mkdir $out

      ${if config.boot.initrd.systemd.enable then ''
        cp ${config.system.build.bootStage2} $out/prepare-root
        substituteInPlace $out/prepare-root --subst-var-by systemConfig $out
        # This must not be a symlink or the abs_path of the grub builder for the tests
        # will resolve the symlink and we end up with a path that doesn't point to a
        # system closure.
        cp "$systemd/lib/systemd/systemd" $out/init
      '' else ''
        cp ${config.system.build.bootStage2} $out/init
        substituteInPlace $out/init --subst-var-by systemConfig $out
      ''}

      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw
      ln -s "$systemd" $out/systemd

      echo -n "systemd ${toString config.systemd.package.interfaceVersion}" > $out/init-interface-version
      echo -n "$nixosLabel" > $out/nixos-version
      echo -n "${config.boot.kernelPackages.stdenv.hostPlatform.system}" > $out/system

      ${config.system.systemBuilderCommands}

      cp "$extraDependenciesPath" "$out/extra-dependencies"

      ${optionalString (!config.boot.isContainer && config.boot.bootspec.enable) ''
        ${config.boot.bootspec.writer}
        ${optionalString config.boot.bootspec.enableValidation
          ''${config.boot.bootspec.validator} "$out/${config.boot.bootspec.filename}"''}
      ''}

      ${config.system.extraSystemBuilderCmds}
    '';

  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, systemd units, init scripts, etc.) as well as a script
  # `switch-to-configuration' that activates the configuration and
  # makes it bootable. See `activatable-system.nix`.
  baseSystem = pkgs.stdenvNoCC.mkDerivation ({
    name = "nixos-system-${config.system.name}-${config.system.nixos.label}";
    preferLocalBuild = true;
    allowSubstitutes = false;
    passAsFile = [ "extraDependencies" ];
    buildCommand = systemBuilder;

    systemd = config.systemd.package;

    nixosLabel = config.system.nixos.label;

    inherit (config.system) extraDependencies;
  } // config.system.systemBuilderArgs);

  # Handle assertions and warnings

  failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);

  baseSystemAssertWarn = if failedAssertions != []
    then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else showWarnings config.warnings baseSystem;

  # Replace runtime dependencies
  system = foldr ({ oldDependency, newDependency }: drv:
      pkgs.replaceDependency { inherit oldDependency newDependency drv; }
    ) baseSystemAssertWarn config.system.replaceRuntimeDependencies;

  systemWithBuildDeps = system.overrideAttrs (o: {
    systemBuildClosure = pkgs.closureInfo { rootPaths = [ system.drvPath ]; };
    buildCommand = o.buildCommand + ''
      ln -sn $systemBuildClosure $out/build-closure
    '';
  });

in

{
  imports = [
    ../build.nix
    (mkRemovedOptionModule [ "nesting" "clone" ] "Use `specialisation.«name» = { inheritParentConfig = true; configuration = { ... }; }` instead.")
    (mkRemovedOptionModule [ "nesting" "children" ] "Use `specialisation.«name».configuration = { ... }` instead.")
  ];

  options = {

    system.boot.loader.id = mkOption {
      internal = true;
      default = "";
      description = lib.mdDoc ''
        Id string of the used bootloader.
      '';
    };

    system.boot.loader.kernelFile = mkOption {
      internal = true;
      default = pkgs.stdenv.hostPlatform.linux-kernel.target;
      defaultText = literalExpression "pkgs.stdenv.hostPlatform.linux-kernel.target";
      type = types.str;
      description = lib.mdDoc ''
        Name of the kernel file to be passed to the bootloader.
      '';
    };

    system.boot.loader.initrdFile = mkOption {
      internal = true;
      default = "initrd";
      type = types.str;
      description = lib.mdDoc ''
        Name of the initrd file to be passed to the bootloader.
      '';
    };

    system.build = {
      toplevel = mkOption {
        type = types.package;
        readOnly = true;
        description = lib.mdDoc ''
          This option contains the store path that typically represents a NixOS system.

          You can read this path in a custom deployment tool for example.
        '';
      };
    };


    system.copySystemConfiguration = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        If enabled, copies the NixOS configuration file
        (usually {file}`/etc/nixos/configuration.nix`)
        and links it from the resulting system
        (getting to {file}`/run/current-system/configuration.nix`).
        Note that only this single file is copied, even if it imports others.
      '';
    };

    system.systemBuilderCommands = mkOption {
      type = types.lines;
      internal = true;
      default = "";
      description = ''
        This code will be added to the builder creating the system store path.
      '';
    };

    system.systemBuilderArgs = mkOption {
      type = types.attrsOf types.unspecified;
      internal = true;
      default = {};
      description = lib.mdDoc ''
        `lib.mkDerivation` attributes that will be passed to the top level system builder.
      '';
    };

    system.forbiddenDependenciesRegex = mkOption {
      default = "";
      example = "-dev$";
      type = types.str;
      description = lib.mdDoc ''
        A POSIX Extended Regular Expression that matches store paths that
        should not appear in the system closure, with the exception of {option}`system.extraDependencies`, which is not checked.
      '';
    };

    system.extraSystemBuilderCmds = mkOption {
      type = types.lines;
      internal = true;
      default = "";
      description = lib.mdDoc ''
        This code will be added to the builder creating the system store path.
      '';
    };

    system.extraDependencies = mkOption {
      type = types.listOf types.pathInStore;
      default = [];
      description = lib.mdDoc ''
        A list of paths that should be included in the system
        closure but generally not visible to users.

        This option has also been used for build-time checks, but the
        `system.checks` option is more appropriate for that purpose as checks
        should not leave a trace in the built system configuration.
      '';
    };

    system.checks = mkOption {
      type = types.listOf types.package;
      default = [];
      description = lib.mdDoc ''
        Packages that are added as dependencies of the system's build, usually
        for the purpose of validating some part of the configuration.

        Unlike `system.extraDependencies`, these store paths do not
        become part of the built system configuration.
      '';
    };

    system.replaceRuntimeDependencies = mkOption {
      default = [];
      example = lib.literalExpression "[ ({ original = pkgs.openssl; replacement = pkgs.callPackage /path/to/openssl { }; }) ]";
      type = types.listOf (types.submodule (
        { ... }: {
          options.original = mkOption {
            type = types.package;
            description = lib.mdDoc "The original package to override.";
          };

          options.replacement = mkOption {
            type = types.package;
            description = lib.mdDoc "The replacement package.";
          };
        })
      );
      apply = map ({ original, replacement, ... }: {
        oldDependency = original;
        newDependency = replacement;
      });
      description = lib.mdDoc ''
        List of packages to override without doing a full rebuild.
        The original derivation and replacement derivation must have the same
        name length, and ideally should have close-to-identical directory layout.
      '';
    };

    system.name = mkOption {
      type = types.str;
      default =
        if config.networking.hostName == ""
        then "unnamed"
        else config.networking.hostName;
      defaultText = literalExpression ''
        if config.networking.hostName == ""
        then "unnamed"
        else config.networking.hostName;
      '';
      description = lib.mdDoc ''
        The name of the system used in the {option}`system.build.toplevel` derivation.

        That derivation has the following name:
        `"nixos-system-''${config.system.name}-''${config.system.nixos.label}"`
      '';
    };

    system.includeBuildDependencies = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to include the build closure of the whole system in
        its runtime closure.  This can be useful for making changes
        fully offline, as it includes all sources, patches, and
        intermediate outputs required to build all the derivations
        that the system depends on.

        Note that this includes _all_ the derivations, down from the
        included applications to their sources, the compilers used to
        build them, and even the bootstrap compiler used to compile
        the compilers. This increases the size of the system and the
        time needed to download its dependencies drastically: a
        minimal configuration with no extra services enabled grows
        from ~670MiB in size to 13.5GiB, and takes proportionally
        longer to download.
      '';
    };

  };


  config = {
    assertions = [
      {
        assertion = config.system.copySystemConfiguration -> !lib.inPureEvalMode;
        message = "system.copySystemConfiguration is not supported with flakes";
      }
    ];

    system.extraSystemBuilderCmds =
      optionalString
        config.system.copySystemConfiguration
        ''ln -s '${import ../../../lib/from-env.nix "NIXOS_CONFIG" <nixos-config>}' \
            "$out/configuration.nix"
        '' +
      optionalString
        (config.system.forbiddenDependenciesRegex != "")
        ''
          if [[ $forbiddenDependenciesRegex != "" && -n $closureInfo ]]; then
            if forbiddenPaths="$(grep -E -- "$forbiddenDependenciesRegex" $closureInfo/store-paths)"; then
              echo -e "System closure $out contains the following disallowed paths:\n$forbiddenPaths"
              exit 1
            fi
          fi
        '';

    system.systemBuilderArgs = {

      # Legacy environment variables. These were used by the activation script,
      # but some other script might still depend on them, although unlikely.
      installBootLoader = config.system.build.installBootLoader;
      localeArchive = "${config.i18n.glibcLocales}/lib/locale/locale-archive";
      distroId = config.system.nixos.distroId;
      perl = pkgs.perl.withPackages (p: with p; [ ConfigIniFiles FileSlurp ]);
      # End if legacy environment variables


      # Not actually used in the builder. `passedChecks` is just here to create
      # the build dependencies. Checks are similar to build dependencies in the
      # sense that if they fail, the system build fails. However, checks do not
      # produce any output of value, so they are not used by the system builder.
      # In fact, using them runs the risk of accidentally adding unneeded paths
      # to the system closure, which defeats the purpose of the `system.checks`
      # option, as opposed to `system.extraDependencies`.
      passedChecks = concatStringsSep " " config.system.checks;
    }
    // lib.optionalAttrs (config.system.forbiddenDependenciesRegex != "") {
      inherit (config.system) forbiddenDependenciesRegex;
      closureInfo = pkgs.closureInfo { rootPaths = [
        # override to avoid  infinite recursion (and to allow using extraDependencies to add forbidden dependencies)
        (config.system.build.toplevel.overrideAttrs (_: { extraDependencies = []; closureInfo = null; }))
      ]; };
    };


    system.build.toplevel = if config.system.includeBuildDependencies then systemWithBuildDeps else system;

  };

}
