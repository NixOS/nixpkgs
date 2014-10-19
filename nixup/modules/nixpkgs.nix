{ config, lib, ... }:

with lib;

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

  configType = mkOptionType {
    name = "nixpkgs config";
    check = traceValIfNot isConfig;
    merge = args: fold (def: mergeConfig def.value) {};
  };

in

{
  options = {
    nixpkgs.path = mkOption {
      type = types.path;
      example = "/home/user/dev/nixpkgs";
      description = ''
        Location of the collection of packages which is used for building
        the current user profile.  This is also useful for building profile
        against either bleeding-edge recipes or archived version of the
        recipes.
      '';
    };

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
      type = configType;
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
      description = ''
        Specifies the Nix platform type for which NixOS should be built.
        If unset, it defaults to the platform type of your host system.
        Specifying this option is useful when doing distributed
        multi-platform deployment, or when building virtual machines.
      '';
    };

    nixpkgs.pkgs = mkOption {
      type = types.attrs;
      internal = true;
      description = ''
        Attribute set containing the collection of packages imported from
        the <option>nixpkgs.path</option>.
      '';
    };
  };

  config = mkDefault {
    nixpkgs.path = <nixpkgs>;
    nixpkgs.pkgs = import config.nixpkgs.path { inherit (config.nixpkgs) system config; };
  };
}
