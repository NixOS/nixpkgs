{ config, pkgs, ... }:

with pkgs.lib;

let
  isConfig = x:
    builtins.isAttrs x || builtins.isFunction x;

  optCall = f: x:
    if builtins.isFunction f
    then f x
    else f;

  mergeConfig = lhs: rhs:
    lhs // rhs //
    optionalAttrs (lhs ? packageOverrides) {
      packageOverrides = pkgs:
        optCall lhs.packageOverrides pkgs //
        optCall (attrByPath ["packageOverrides"] ({}) rhs) pkgs;
    };

  configType = mkOptionType {
    name = "nixpkgs config";
    check = traceValIfNot isConfig;
    merge = fold mergeConfig {};
  };

in

{
  options = {

    nixpkgs.config = pkgs.lib.mkOption {
      default = {};
      example = {
        firefox.enableGeckoMediaPlayer = true;
      };
      type = configType;
      description = ''
        The configuration of the Nix Packages collection.  This expression
        defines default value of attributes and allow packages to be
        overriden globally via the `packageOverrides'.

        the `packageOverrides' configuration option must be a set of new or
        overriden packages.  Any occurence of `pkgs' inside this attribute
        set refers to the *original* (un-overriden) set of packages,
        allowing packageOverrides attributes to refer to the original
        attributes (e.g. "packageOverrides.foo = ... pkgs.foo ...").
      '';
    };

    nixpkgs.system = pkgs.lib.mkOption {
      default = "";
      description = ''
        Specifies the Nix platform type for which NixOS should be built.
        If unset, it defaults to the platform type of your host system
        (<literal>${builtins.currentSystem}</literal>).
        Specifying this option is useful when doing distributed
        multi-platform deployment, or when building virtual machines.
      '';
    };

  };
}
