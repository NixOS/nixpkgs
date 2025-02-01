{ config, options, lib, pkgs, ... }:
let
  cfg = config.nixpkgs;
  opt = options.nixpkgs;

  isConfig = x:
    builtins.isAttrs x || lib.isFunction x;

  optCall = f: x:
    if lib.isFunction f
    then f x
    else f;

  mergeConfig = lhs_: rhs_:
    let
      lhs = optCall lhs_ { inherit pkgs; };
      rhs = optCall rhs_ { inherit pkgs; };
    in
    lib.recursiveUpdate lhs rhs //
    lib.optionalAttrs (lhs ? packageOverrides) {
      packageOverrides = pkgs:
        optCall lhs.packageOverrides pkgs //
        optCall (lib.attrByPath [ "packageOverrides" ] { } rhs) pkgs;
    } //
    lib.optionalAttrs (lhs ? perlPackageOverrides) {
      perlPackageOverrides = pkgs:
        optCall lhs.perlPackageOverrides pkgs //
        optCall (lib.attrByPath [ "perlPackageOverrides" ] { } rhs) pkgs;
    };

  configType = lib.mkOptionType {
    name = "nixpkgs-config";
    description = "nixpkgs config";
    check = x:
      let traceXIfNot = c:
            if c x then true
            else lib.traceSeqN 1 x false;
      in traceXIfNot isConfig;
    merge = args: lib.foldr (def: mergeConfig def.value) {};
  };

  overlayType = lib.mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };

  pkgsType = lib.types.pkgs // {
    # This type is only used by itself, so let's elaborate the description a bit
    # for the purpose of documentation.
    description = "An evaluation of Nixpkgs; the top level attribute set of packages";
  };

  hasBuildPlatform = opt.buildPlatform.highestPrio < (lib.mkOptionDefault {}).priority;
  hasHostPlatform = opt.hostPlatform.isDefined;
  hasPlatform = hasHostPlatform || hasBuildPlatform;

  # Context for messages
  hostPlatformLine = lib.optionalString hasHostPlatform "${lib.showOptionWithDefLocs opt.hostPlatform}";
  buildPlatformLine = lib.optionalString hasBuildPlatform "${lib.showOptionWithDefLocs opt.buildPlatform}";

  legacyOptionsDefined =
    lib.optional (opt.localSystem.highestPrio < (lib.mkDefault {}).priority) opt.system
    ++ lib.optional (opt.localSystem.highestPrio < (lib.mkOptionDefault {}).priority) opt.localSystem
    ++ lib.optional (opt.crossSystem.highestPrio < (lib.mkOptionDefault {}).priority) opt.crossSystem
    ;

  defaultPkgs =
    if opt.hostPlatform.isDefined
    then
      let isCross = cfg.buildPlatform != cfg.hostPlatform;
          systemArgs =
            if isCross
            then {
              localSystem = cfg.buildPlatform;
              crossSystem = cfg.hostPlatform;
            }
            else {
              localSystem = cfg.hostPlatform;
            };
      in
      import ../../.. ({
        inherit (cfg) config overlays;
      } // systemArgs)
    else
      import ../../.. {
        inherit (cfg) config overlays localSystem crossSystem;
      };

  finalPkgs = if opt.pkgs.isDefined then cfg.pkgs.appendOverlays cfg.overlays else defaultPkgs;

in

{
  imports = [
    ./assertions.nix
    ./meta.nix
    (lib.mkRemovedOptionModule [ "nixpkgs" "initialSystem" ] "The NixOS options `nesting.clone` and `nesting.children` have been deleted, and replaced with named specialisation. Therefore `nixpgks.initialSystem` has no effect anymore.")
  ];

  options.nixpkgs = {

    pkgs = lib.mkOption {
      defaultText = lib.literalExpression ''
        import "''${nixos}/.." {
          inherit (cfg) config overlays localSystem crossSystem;
        }
      '';
      type = pkgsType;
      example = lib.literalExpression "import <nixpkgs> {}";
      description = ''
        If set, the pkgs argument to all NixOS modules is the value of
        this option, extended with `nixpkgs.overlays`, if
        that is also set. Either `nixpkgs.crossSystem` or
        `nixpkgs.localSystem` will be used in an assertion
        to check that the NixOS and Nixpkgs architectures match. Any
        other options in `nixpkgs.*`, notably `config`,
        will be ignored.

        If unset, the pkgs argument to all NixOS modules is determined
        as shown in the default value for this option.

        The default value imports the Nixpkgs source files
        relative to the location of this NixOS module, because
        NixOS and Nixpkgs are distributed together for consistency,
        so the `nixos` in the default value is in fact a
        relative path. The `config`, `overlays`,
        `localSystem`, and `crossSystem` come
        from this option's siblings.

        This option can be used by applications like NixOps to increase
        the performance of evaluation, or to create packages that depend
        on a container that should be built with the exact same evaluation
        of Nixpkgs, for example. Applications like this should set
        their default value using `lib.mkDefault`, so
        user-provided configuration can override it without using
        `lib`.

        Note that using a distinct version of Nixpkgs with NixOS may
        be an unexpected source of problems. Use this option with care.
      '';
    };

    config = lib.mkOption {
      default = {};
      example = lib.literalExpression
        ''
          { allowBroken = true; allowUnfree = true; }
        '';
      type = configType;
      description = ''
        Global configuration for Nixpkgs.
        The complete list of [Nixpkgs configuration options](https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference) is in the [Nixpkgs manual section on global configuration](https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig).

        Ignored when {option}`nixpkgs.pkgs` is set.
      '';
    };

    overlays = lib.mkOption {
      default = [];
      example = lib.literalExpression
        ''
          [
            (self: super: {
              openssh = super.openssh.override {
                hpnSupport = true;
                kerberos = self.libkrb5;
              };
            })
          ]
        '';
      type = lib.types.listOf overlayType;
      description = ''
        List of overlays to apply to Nixpkgs.
        This option allows modifying the Nixpkgs package set accessed through the `pkgs` module argument.

        For details, see the [Overlays chapter in the Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#chap-overlays).

        If the {option}`nixpkgs.pkgs` option is set, overlays specified using `nixpkgs.overlays` will be applied after the overlays that were already included in `nixpkgs.pkgs`.
      '';
    };

    hostPlatform = lib.mkOption {
      type = lib.types.either lib.types.str lib.types.attrs; # TODO utilize lib.systems.parsedPlatform
      example = { system = "aarch64-linux"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this. TODO make `lib.systems` itself use the module system.
      apply = lib.systems.elaborate;
      defaultText = lib.literalExpression
        ''(import "''${nixos}/../lib").lib.systems.examples.aarch64-multiplatform'';
      description = ''
        Specifies the platform where the NixOS configuration will run.

        To cross-compile, set also `nixpkgs.buildPlatform`.

        Ignored when `nixpkgs.pkgs` is set.
      '';
    };

    buildPlatform = lib.mkOption {
      type = lib.types.either lib.types.str lib.types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = cfg.hostPlatform;
      example = { system = "x86_64-linux"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this.
      apply = inputBuildPlatform:
        let elaborated = lib.systems.elaborate inputBuildPlatform;
        in if lib.systems.equals elaborated cfg.hostPlatform
          then cfg.hostPlatform  # make identical, so that `==` equality works; see https://github.com/NixOS/nixpkgs/issues/278001
          else elaborated;
      defaultText = lib.literalExpression
        ''config.nixpkgs.hostPlatform'';
      description = ''
        Specifies the platform on which NixOS should be built.
        By default, NixOS is built on the system where it runs, but you can
        change where it's built. Setting this option will cause NixOS to be
        cross-compiled.

        For instance, if you're doing distributed multi-platform deployment,
        or if you're building machines, you can set this to match your
        development system and/or build farm.

        Ignored when `nixpkgs.pkgs` is set.
      '';
    };

    localSystem = lib.mkOption {
      type = lib.types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = { inherit (cfg) system; };
      example = { system = "aarch64-linux"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this. TODO make `lib.systems` itself use the module system.
      apply = lib.systems.elaborate;
      defaultText = lib.literalExpression
        ''(import "''${nixos}/../lib").lib.systems.examples.aarch64-multiplatform'';
      description = ''
        Systems with a recently generated `hardware-configuration.nix`
        do not need to specify this option, unless cross-compiling, in which case
        you should set *only* {option}`nixpkgs.buildPlatform`.

        If this is somehow not feasible, you may fall back to removing the
        {option}`nixpkgs.hostPlatform` line from the generated config and
        use the old options.

        Specifies the platform on which NixOS should be built. When
        `nixpkgs.crossSystem` is unset, it also specifies
        the platform *for* which NixOS should be
        built.  If this option is unset, it defaults to the platform
        type of the machine where evaluation happens. Specifying this
        option is useful when doing distributed multi-platform
        deployment, or when building virtual machines. See its
        description in the Nixpkgs manual for more details.

        Ignored when `nixpkgs.pkgs` or `hostPlatform` is set.
      '';
    };

    # TODO deprecate. "crossSystem" is a nonsense identifier, because "cross"
    #      is a relation between at least 2 systems in the context of a
    #      specific build step, not a single system.
    crossSystem = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = null;
      example = { system = "aarch64-linux"; };
      description = ''
        Systems with a recently generated `hardware-configuration.nix`
        may instead specify *only* {option}`nixpkgs.buildPlatform`,
        or fall back to removing the {option}`nixpkgs.hostPlatform` line from the generated config.

        Specifies the platform for which NixOS should be
        built. Specify this only if it is different from
        `nixpkgs.localSystem`, the platform
        *on* which NixOS should be built. In other
        words, specify this to cross-compile NixOS. Otherwise it
        should be set as null, the default. See its description in the
        Nixpkgs manual for more details.

        Ignored when `nixpkgs.pkgs` or `hostPlatform` is set.
      '';
    };

    system = lib.mkOption {
      type = lib.types.str;
      example = "i686-linux";
      default =
        if opt.hostPlatform.isDefined
        then
          throw ''
            Neither ${opt.system} nor any other option in nixpkgs.* is meant
            to be read by modules and configurations.
            Use pkgs.stdenv.hostPlatform instead.
          ''
        else
          throw ''
            Neither ${opt.hostPlatform} nor the legacy option ${opt.system} has been set.
            You can set ${opt.hostPlatform} in hardware-configuration.nix by re-running
            a recent version of nixos-generate-config.
            The option ${opt.system} is still fully supported for NixOS 22.05 interoperability,
            but will be deprecated in the future, so we recommend to set ${opt.hostPlatform}.
          '';
      defaultText = lib.literalMD ''
        Traditionally `builtins.currentSystem`, but unset when invoking NixOS through `lib.nixosSystem`.
      '';
      description = ''
        This option does not need to be specified for NixOS configurations
        with a recently generated `hardware-configuration.nix`.

        Specifies the Nix platform type on which NixOS should be built.
        It is better to specify `nixpkgs.localSystem` instead.
        ```
        {
          nixpkgs.system = ..;
        }
        ```
        is the same as
        ```
        {
          nixpkgs.localSystem.system = ..;
        }
        ```
        See `nixpkgs.localSystem` for more information.

        Ignored when `nixpkgs.pkgs`, `nixpkgs.localSystem` or `nixpkgs.hostPlatform` is set.
      '';
    };
  };

  config = {
    _module.args = {
      pkgs =
        # We explicitly set the default override priority, so that we do not need
        # to evaluate finalPkgs in case an override is placed on `_module.args.pkgs`.
        # After all, to determine a definition priority, we need to evaluate `._type`,
        # which is somewhat costly for Nixpkgs. With an explicit priority, we only
        # evaluate the wrapper to find out that the priority is lower, and then we
        # don't need to evaluate `finalPkgs`.
        lib.mkOverride lib.modules.defaultOverridePriority
          finalPkgs.__splicedPackages;
    };

    assertions = let
      # Whether `pkgs` was constructed by this module. This is false when any of
      # nixpkgs.pkgs or _module.args.pkgs is set.
      constructedByMe =
        # We set it with default priority and it can not be merged, so if the
        # pkgs module argument has that priority, it's from us.
        (lib.modules.mergeAttrDefinitionsWithPrio options._module.args).pkgs.highestPrio
          == lib.modules.defaultOverridePriority
        # Although, if nixpkgs.pkgs is set, we did forward it, but we did not construct it.
          && !opt.pkgs.isDefined;
    in [
      (
        let
          nixosExpectedSystem =
            if config.nixpkgs.crossSystem != null
            then config.nixpkgs.crossSystem.system or (lib.systems.parse.doubleFromSystem (lib.systems.parse.mkSystemFromString config.nixpkgs.crossSystem.config))
            else config.nixpkgs.localSystem.system or (lib.systems.parse.doubleFromSystem (lib.systems.parse.mkSystemFromString config.nixpkgs.localSystem.config));
          nixosOption =
            if config.nixpkgs.crossSystem != null
            then "nixpkgs.crossSystem"
            else "nixpkgs.localSystem";
          pkgsSystem = finalPkgs.stdenv.targetPlatform.system;
        in {
          assertion = constructedByMe -> !hasPlatform -> nixosExpectedSystem == pkgsSystem;
          message = "The NixOS nixpkgs.pkgs option was set to a Nixpkgs invocation that compiles to target system ${pkgsSystem} but NixOS was configured for system ${nixosExpectedSystem} via NixOS option ${nixosOption}. The NixOS system settings must match the Nixpkgs target system.";
        }
      )
      {
        assertion = constructedByMe -> hasPlatform -> legacyOptionsDefined == [];
        message = ''
          Your system configures nixpkgs with the platform parameter${lib.optionalString hasBuildPlatform "s"}:
          ${hostPlatformLine
          }${buildPlatformLine
          }
          However, it also defines the legacy options:
          ${lib.concatMapStrings lib.showOptionWithDefLocs legacyOptionsDefined}
          For a future proof system configuration, we recommend to remove
          the legacy definitions.
        '';
      }
      {
        assertion = opt.pkgs.isDefined -> cfg.config == {};
        message = ''
          Your system configures nixpkgs with an externally created instance.
          `nixpkgs.config` options should be passed when creating the instance instead.

          Current value:
          ${lib.generators.toPretty { multiline = true; } opt.config}
        '';
      }
    ];
  };

  # needs a full nixpkgs path to import nixpkgs
  meta.buildDocsInSandbox = false;
}
