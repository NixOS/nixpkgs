{ lib, config, ... }:
let
  inherit (lib) mkOption types;

  nixpkgsOverlaySubmodule = types.mkOptionType {
    name = "nixpkgsOverlay";
    description = "A nixpkgs overlay function";
    descriptionClass = "noun";
    check = lib.isFunction;
    merge = _loc: defs:
      let
        logWarning =
          if builtins.length defs > 1
          then builtins.trace "WARNING[nixpkgs.flakeModule]: Multiple overlays are applied in arbitrary order." null
          else null;
        overlays =
          map (x: x.value)
            (builtins.seq
              logWarning
              defs);
      in
      lib.composeManyExtensions overlays;
  };

  mkPkgsFromSystemType = types.mkOptionType {
    name = "mkPkgsfromsystem";
    description = "";
    descriptionClass = "noun";
    check = lib.isFunction;
  };

  nixpkgsSubmodule = with types; submodule {
    options = {
      overlays = mkOption {
        type = listOf nixpkgsOverlaySubmodule;
        description = "Nixpkgs overlays";
        default = [ ];
      };

      mkPkgsFromSystem = mkOption {
        type = mkPkgsFromSystemType;
        description = "Returns `pkgs` from `system";
        internal = true;
        default = system: import ./. { inherit system; inherit (config.nixpkgs) overlays; };
      };

      allPkgsPerSystem = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        description = "Attribute set of `pkgs` named by `system`";
        internal = true;
        default = genAttrs lib.systems.parsedPlatform config.nixpkgs.mkPkgsFromSystem;
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
