{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixpkgs;

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
    check = traceValIfNot isConfig;
    merge = args: fold (def: mergeConfig def.value) {};
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

in

{
  options.nixpkgs = {

    pkgs = mkOption {
      defaultText = literalExample
        ''import "''${nixos}/.." {
            inherit (config.nixpkgs) config overlays system;
          }
        '';
      default = import ../../.. { inherit (cfg) config overlays system crossSystem; };
      type = pkgsType;
      example = literalExample ''import <nixpkgs> {}'';
      description = ''
        This is the evaluation of Nixpkgs that will be provided to
        all NixOS modules. Defining this option has the effect of
        ignoring the other options that would otherwise be used to
        evaluate Nixpkgs, because those are arguments to the default
        value. The default value imports the Nixpkgs source files
        relative to the location of this NixOS module, because
        NixOS and Nixpkgs are distributed together for consistency,
        so the <code>nixos</code> in the default value is in fact a
        relative path. The <code>config</code>, <code>overlays</code>
        and <code>system</code> come from this option's siblings.

        This option can be used by applications like NixOps to increase
        the performance of evaluation, or to create packages that depend
        on a container that should be built with the exact same evaluation
        of Nixpkgs, for example. Applications like this should set
        their default value using <code>lib.mkDefault</code>, so
        user-provided configuration can override it without using
        <code>lib</code>.

        Note that using a distinct version of Nixpkgs with NixOS may
        be an unexpected source of problems. Use this option with care.
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
        you to override packages globally. This is a function that
        takes as an argument the <emphasis>original</emphasis> Nixpkgs.
        The first argument should be used for finding dependencies, and
        the second should be used for overriding recipes.

        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };

    crossSystem = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = ''
        The description of the system we're cross-compiling to, or null
        if this isn't a cross-compile. See the description of the
        crossSystem argument in the nixpkgs manual.

        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };

    system = mkOption {
      type = types.str;
      example = "i686-linux";
      description = ''
        Specifies the Nix platform type for which NixOS should be built.
        If unset, it defaults to the platform type of your host system.
        Specifying this option is useful when doing distributed
        multi-platform deployment, or when building virtual machines.

        Ignored when <code>nixpkgs.pkgs</code> is set.
      '';
    };
  };

  config = {
    _module.args = {
      pkgs = cfg.pkgs;
      pkgs_i686 = cfg.pkgs.pkgsi686Linux;
    };
  };
}
