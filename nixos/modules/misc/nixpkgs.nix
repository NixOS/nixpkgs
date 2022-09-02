{ config, options, lib, pkgs, ... }:

with lib;

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
    recursiveUpdate lhs rhs //
    optionalAttrs (lhs ? packageOverrides) {
      packageOverrides = pkgs:
        optCall lhs.packageOverrides pkgs //
        optCall (attrByPath ["packageOverrides"] ({}) rhs) pkgs;
    } //
    optionalAttrs (lhs ? perlPackageOverrides) {
      perlPackageOverrides = pkgs:
        optCall lhs.perlPackageOverrides pkgs //
        optCall (attrByPath ["perlPackageOverrides"] ({}) rhs) pkgs;
    };

  configType = mkOptionType {
    name = "nixpkgs-config";
    description = "nixpkgs config";
    check = x:
      let traceXIfNot = c:
            if c x then true
            else lib.traceSeqN 1 x false;
      in traceXIfNot isConfig;
    merge = args: foldr (def: mergeConfig def.value) {};
  };

  overlayType = mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };

  pkgsType = mkOptionType {
    name = "nixpkgs";
    description = "An evaluation of Nixpkgs; the top level attribute set of packages";
    check = builtins.isAttrs;
  };

  hasBuildPlatform = opt.buildPlatform.highestPrio < (mkOptionDefault {}).priority;
  hasHostPlatform = opt.hostPlatform.isDefined;
  hasPlatform = hasHostPlatform || hasBuildPlatform;

  # Context for messages
  hostPlatformLine = optionalString hasHostPlatform "${showOptionWithDefLocs opt.hostPlatform}";
  buildPlatformLine = optionalString hasBuildPlatform "${showOptionWithDefLocs opt.buildPlatform}";
  platformLines = optionalString hasPlatform ''
    Your system configuration configures nixpkgs with platform parameters:
    ${hostPlatformLine
    }${buildPlatformLine
    }'';

  legacyOptionsDefined =
    optional (opt.localSystem.highestPrio < (mkDefault {}).priority) opt.system
    ++ optional (opt.localSystem.highestPrio < (mkOptionDefault {}).priority) opt.localSystem
    ++ optional (opt.crossSystem.highestPrio < (mkOptionDefault {}).priority) opt.crossSystem
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
    (mkRemovedOptionModule [ "nixpkgs" "initialSystem" ] "The NixOS options `nesting.clone` and `nesting.children` have been deleted, and replaced with named specialisation. Therefore `nixpgks.initialSystem` has no effect anymore.")
  ];

  options.nixpkgs = {

    pkgs = mkOption {
      defaultText = literalExpression ''
        import "''${nixos}/.." {
          inherit (cfg) config overlays localSystem crossSystem;
        }
      '';
      type = pkgsType;
      example = literalExpression "import <nixpkgs> {}";
      description = lib.mdDoc ''
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

    config = mkOption {
      default = {};
      example = literalExpression
        ''
          { allowBroken = true; allowUnfree = true; }
        '';
      type = configType;
      description = lib.mdDoc ''
        The configuration of the Nix Packages collection.  (For
        details, see the Nixpkgs documentation.)  It allows you to set
        package configuration options.

        Ignored when `nixpkgs.pkgs` is set.
      '';
    };

    overlays = mkOption {
      default = [];
      example = literalExpression
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
      type = types.listOf overlayType;
      description = lib.mdDoc ''
        List of overlays to use with the Nix Packages collection.
        (For details, see the Nixpkgs documentation.)  It allows
        you to override packages globally. Each function in the list
        takes as an argument the *original* Nixpkgs.
        The first argument should be used for finding dependencies, and
        the second should be used for overriding recipes.

        If `nixpkgs.pkgs` is set, overlays specified here
        will be applied after the overlays that were already present
        in `nixpkgs.pkgs`.
      '';
    };

    hostPlatform = mkOption {
      type = types.either types.str types.attrs; # TODO utilize lib.systems.parsedPlatform
      example = { system = "aarch64-linux"; config = "aarch64-unknown-linux-gnu"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this. TODO make `lib.systems` itself use the module system.
      apply = lib.systems.elaborate;
      defaultText = literalExpression
        ''(import "''${nixos}/../lib").lib.systems.examples.aarch64-multiplatform'';
      description = lib.mdDoc ''
        Specifies the platform where the NixOS configuration will run.

        To cross-compile, set also `nixpkgs.buildPlatform`.

        Ignored when `nixpkgs.pkgs` is set.
      '';
    };

    buildPlatform = mkOption {
      type = types.either types.str types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = cfg.hostPlatform;
      example = { system = "x86_64-linux"; config = "x86_64-unknown-linux-gnu"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this.
      apply = lib.systems.elaborate;
      defaultText = literalExpression
        ''config.nixpkgs.hostPlatform'';
      description = lib.mdDoc ''
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

    localSystem = mkOption {
      type = types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = { inherit (cfg) system; };
      example = { system = "aarch64-linux"; config = "aarch64-unknown-linux-gnu"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this. TODO make `lib.systems` itself use the module system.
      apply = lib.systems.elaborate;
      defaultText = literalExpression
        ''(import "''${nixos}/../lib").lib.systems.examples.aarch64-multiplatform'';
      description = lib.mdDoc ''
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
    crossSystem = mkOption {
      type = types.nullOr types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = null;
      example = { system = "aarch64-linux"; config = "aarch64-unknown-linux-gnu"; };
      description = lib.mdDoc ''
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

    system = mkOption {
      type = types.str;
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
            Neither ${opt.hostPlatform} nor or the legacy option ${opt.system} has been set.
            You can set ${opt.hostPlatform} in hardware-configuration.nix by re-running
            a recent version of nixos-generate-config.
            The option ${opt.system} is still fully supported for NixOS 22.05 interoperability,
            but will be deprecated in the future, so we recommend to set ${opt.hostPlatform}.
          '';
      defaultText = lib.literalMD ''
        Traditionally `builtins.currentSystem`, but unset when invoking NixOS through `lib.nixosSystem`.
      '';
      description = lib.mdDoc ''
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
      pkgs = finalPkgs;
    };

    assertions = [
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
          assertion = !hasPlatform -> nixosExpectedSystem == pkgsSystem;
          message = "The NixOS nixpkgs.pkgs option was set to a Nixpkgs invocation that compiles to target system ${pkgsSystem} but NixOS was configured for system ${nixosExpectedSystem} via NixOS option ${nixosOption}. The NixOS system settings must match the Nixpkgs target system.";
        }
      )
      {
        assertion = hasPlatform -> legacyOptionsDefined == [];
        message = ''
          Your system configures nixpkgs with the platform parameter${optionalString hasBuildPlatform "s"}:
          ${hostPlatformLine
          }${buildPlatformLine
          }
          However, it also defines the legacy options:
          ${concatMapStrings showOptionWithDefLocs legacyOptionsDefined}
          For a future proof system configuration, we recommend to remove
          the legacy definitions.
        '';
      }
    ];
  };

  # needs a full nixpkgs path to import nixpkgs
  meta.buildDocsInSandbox = false;
}
