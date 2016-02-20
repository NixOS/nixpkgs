{ config, lib, pkgs, ... }:

with lib;

let
  nixpkgsConfig = pkgs:
    let
      isConfig = x:
        builtins.isAttrs x || builtins.isFunction x;

      optCall = f: x:
        if builtins.isFunction f
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
        };
    in
    mkOptionType {
      name = "nixpkgs config";
      typerep = "(nixpkgsConfig)";
      check = lib.traceValIfNot isConfig;
      merge = config: args: fold (def: mergeConfig def.value) {};
      defaultValues = [{}];
    };
in

{
  options = {

    nixpkgs.config = mkOption {
      default = {};
      example = literalExample
        ''
          { firefox.enableGeckoMediaPlayer = true;
            packageOverrides = pkgs: {
              firefox60Pkgs = pkgs.firefox60Pkgs.override {
                enableOfficialBranding = true;
              };
            };
          }
        '';
      type = nixpkgsConfig pkgs;
      description = ''
        The configuration of the Nix Packages collection.  (For
        details, see the Nixpkgs documentation.)  It allows you to set
        package configuration options, and to override packages
        globally through the <varname>packageOverrides</varname>
        option.  The latter is a function that takes as an argument
        the <emphasis>original</emphasis> Nixpkgs, and must evaluate
        to a set of new or overridden packages.
      '';
    };

    nixpkgs.system = mkOption {
      type = types.str;
      example = "i686-linux";
      description = ''
        Specifies the Nix platform type for which NixOS should be built.
        If unset, it defaults to the platform type of your host system.
        Specifying this option is useful when doing distributed
        multi-platform deployment, or when building virtual machines.
      '';
    };

  };

  config = {
    _module.args.pkgs = import ../../.. {
      system = config.nixpkgs.system;

      inherit (config.nixpkgs) config;
    };
  };
}
