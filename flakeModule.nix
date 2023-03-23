{ lib, config, ... }:
let
  inherit (lib) mkOption types;

  nixpkgsOverlayType = types.mkOptionType {
    name = "nixpkgsOverlay";
    description = "A nixpkgs overlay function";
    descriptionClass = "noun";
    check = lib.isFunction;
    merge = _loc: defs:
      let
        logWarning =
          # TODO: do not warn when lib.mkOrder/mkBefore/mkAfter are used unambiguously
          if builtins.length defs > 1
          then builtins.trace "WARNING[nixpkgs.flakeModule]: Multiple overlays are applied in arbitrary order." null
          else null;
        overlays =
          map (x: x.value)
            # TODO: lib.warnIf to replace the seq + if
            (builtins.seq
              logWarning
              defs);
      in
      lib.composeManyExtensions overlays;
  };

  mkPkgsFromArgsType = types.mkOptionType {
    name = "mkPkgsFromArgs";
    description = "A function that returns `pkgs` from a set of arguments";
    descriptionClass = "noun";
    check = lib.isFunction;
  };

  pkgsType = types.mkOptionType {
    name = "nixpkgs";
    description = "An evaluation of Nixpkgs; the top level attribute set of packages";
    check = builtins.isAttrs;
  };

  nixpkgsSubmodule = with types; submodule {
    options = {
      overlays = mkOption {
        type = listOf nixpkgsOverlayType;
        description = "Nixpkgs overlays";
        default = [ ];
      };

      mkPkgsFromArgs = mkOption {
        type = mkPkgsFromArgsType;
        description = "Returns `pkgs` from `system";
        internal = true;
        default = args@{ system, overlays ? config.nixpkgs.overlays, ... }:
          import ./. args;
      };

      allPkgsPerSystem = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        description = "Attribute set of `pkgs` named by `system`";
        internal = true;
        default =
          let
            mkPkgsFromSystem = system: mkPkgsFromArgs { inherit system; };
          in
          lib.genAttrs lib.systems.flakeExposed config.nixpkgs.mkPkgsFromSystem;
      };

      # TODO: develop or eliminate
      pkgs = mkOption {
        internal = true;
        type = pkgsType;
      };
    };
  };

in
{
  options = {
    nixpkgs = lib.mkOption {
      type = nixpkgsSubmodule;
      description = "Configuration of nixpkgs";
      default = { };
    };
  };
}
