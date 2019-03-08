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
    lhs // rhs //
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
    merge = args: fold (def: mergeConfig def.value) {};
  };

  overlayType = mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };

  pkgsFunType = mkOptionType {
    name = "nixpkgs";
    description = "An import of nixpkgs";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };

  pkgsType = mkOptionType {
    name = "nixpkgs-evaluated";
    description = "An evaluation of Nixpkgs; the top level attribute set of packages";
    check = builtins.isAttrs;
  };

  defaultPkgs = cfg.pkgsFun {
    inherit (cfg) config overlays localSystem crossSystem;
  };

  finalPkgs = if cfg.pkgs != null then cfg.pkgs.appendOverlays cfg.overlays else defaultPkgs;

in

{
  options.nixpkgs = {

    pkgsFun = mkOption {
      type = pkgsFunType;
      default = import ../../..;
      defaultText = ''import "''${nixos}/.."'';
      example = literalExample ''import <nixpkgs>'';
      description = ''
        A function that evaluates to <code>pkgs</code> argument used
        by all NixOS modules when applied with <code>config</code>,
        <code>overlays</code>, <code>localSystem</code> and
        <code>crossSystem</code>.

        The <code>config</code>, <code>overlays</code>,
        <code>localSystem</code>, and <code>crossSystem</code> come
        from this option's siblings.

        The default value imports the Nixpkgs source files
        relative to the location of this NixOS module, because
        NixOS and Nixpkgs are distributed together for consistency,
        so the <code>nixos</code> in the default value is in fact a
        relative path.

        Note that using a distinct version of Nixpkgs with NixOS may
        be an unexpected source of problems. Use this option with care.
      '';
    };

    # TODO: remove after 20.03
    pkgs = mkOption {
      type = types.nullOr pkgsType;
      default = null;
      example = literalExample ''import <nixpkgs> {}'';
      description = ''
        DEPRECATED, please use <option>nixpkgs.pkgsFun</option> instead.
      '';
    };

    config = mkOption {
      default = {};
      example = literalExample
        ''
          { allowBroken = true; allowUnfree = true; }
        '';
      type = configType;
      description = ''
        The configuration of the Nix Packages collection.  (For
        details, see the Nixpkgs documentation.)  It allows you to set
        package configuration options.

        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };

    overlays = mkOption {
      default = [];
      example = literalExample
        ''
          [ (self: super: {
              openssh = super.openssh.override {
                hpnSupport = true;
                kerberos = self.libkrb5;
              };
            };
          ) ]
        '';
      type = types.listOf overlayType;
      description = ''
        List of overlays to use with the Nix Packages collection.
        (For details, see the Nixpkgs documentation.)  It allows
        you to override packages globally. Each function in the list
        takes as an argument the <emphasis>original</emphasis> Nixpkgs.
        The first argument should be used for finding dependencies, and
        the second should be used for overriding recipes.

        If <code>nixpkgs.pkgs</code> is set, overlays specified here
        will be applied after the overlays that were already present
        in <code>nixpkgs.pkgs</code>.
      '';
    };

    localSystem = mkOption {
      type = types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = { inherit (cfg) system; };
      example = { system = "aarch64-linux"; config = "aarch64-unknown-linux-gnu"; };
      # Make sure that the final value has all fields for sake of other modules
      # referring to this. TODO make `lib.systems` itself use the module system.
      apply = lib.systems.elaborate;
      defaultText = literalExample
        ''(import "''${nixos}/../lib").lib.systems.examples.aarch64-multiplatform'';
      description = ''
        Specifies the platform on which NixOS should be built. When
        <code>nixpkgs.crossSystem</code> is unset, it also specifies
        the platform <emphasis>for</emphasis> which NixOS should be
        built.  If this option is unset, it defaults to the platform
        type of the machine where evaluation happens. Specifying this
        option is useful when doing distributed multi-platform
        deployment, or when building virtual machines. See its
        description in the Nixpkgs manual for more details.

        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };

    crossSystem = mkOption {
      type = types.nullOr types.attrs; # TODO utilize lib.systems.parsedPlatform
      default = null;
      example = { system = "aarch64-linux"; config = "aarch64-unknown-linux-gnu"; };
      defaultText = literalExample
        ''(import "''${nixos}/../lib").lib.systems.examples.aarch64-multiplatform'';
      description = ''
        Specifies the platform for which NixOS should be
        built. Specify this only if it is different from
        <code>nixpkgs.localSystem</code>, the platform
        <emphasis>on</emphasis> which NixOS should be built. In other
        words, specify this to cross-compile NixOS. Otherwise it
        should be set as null, the default. See its description in the
        Nixpkgs manual for more details.

        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };

    system = mkOption {
      type = types.str;
      example = "i686-linux";
      default = { system = builtins.currentSystem; };
      description = ''
        Specifies the Nix platform type on which NixOS should be built.
        It is better to specify <code>nixpkgs.localSystem</code> instead.
        <programlisting>
        {
          nixpkgs.system = ..;
        }
        </programlisting>
        is the same as
        <programlisting>
        {
          nixpkgs.localSystem.system = ..;
        }
        </programlisting>
        See <code>nixpkgs.localSystem</code> for more information.

        Ignored when <code>nixpkgs.localSystem</code> is set.
        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };
  };

  config = {
    _module.args = {
      pkgs = finalPkgs;
    };

    warnings = optional (cfg.pkgs != null) ''
      The option `nixpkgs.pkgs` was deprecated, please use `nixpkgs.pkgsFun` instead.

      The use of `nixpkgs.pkgs` produces 2x slowdown for evaluation of your
      `configuration.nix` because NixOS has to reevaluate `nixpkgs` to reapply
      overlays the second time.
    '';

    assertions = [
      (
        let
          nixosExpectedSystem =
            if cfg.crossSystem != null
            then cfg.crossSystem.system
            else cfg.localSystem.system;
          nixosOption =
            if cfg.crossSystem != null
            then "nixpkgs.crossSystem"
            else "nixpkgs.localSystem";
          pkgsSystem = finalPkgs.stdenv.targetPlatform.system;
        in {
          assertion = nixosExpectedSystem == pkgsSystem;
          message = "The NixOS nixpkgs.pkgs option was set to a Nixpkgs invocation that compiles to target system ${pkgsSystem} but NixOS was configured for system ${nixosExpectedSystem} via NixOS option ${nixosOption}. The NixOS system settings must match the Nixpkgs target system.";
        }
      )
    ];
  };
}
