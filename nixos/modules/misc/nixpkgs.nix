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
            inherit (cfg) config overlays localSystem crossSystem;
          }
        '';
      default = import ../../.. {
        inherit (cfg) config overlays localSystem crossSystem;
      };
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
        relative path. The <code>config</code>, <code>overlays</code>,
        <code>localSystem</code>, and <code>crossSystem</code> come
        from this option's siblings.

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
      pkgs = cfg.pkgs;
      pkgs_i686 = cfg.pkgs.pkgsi686Linux;
    };
  };
}
