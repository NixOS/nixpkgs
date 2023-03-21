{ lib, config, system, ... }:
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

  nixpkgsSubmodule = with types; submodule {
    options = {
      overlays = mkOption {
        type = listOf nixpkgsOverlaySubmodule;
        description = "Nixpkgs overlays";
        default = [ ];
      };

      output = mkOption {
        type = listOf nixpkgsOverlaySubmodule;
        description = "Output pkgs from nixpkgs' flake module";
        default = import ./.
          { inherit system; inherit (config.nixpkgs) overlays; };
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
