{ lib, config, system, ... }:
let
  inherit (lib) mkOption types;
  nixpkgsOverlaySubmodule = lib.types.mkOptionType {
    name = "nixpkgsOverlay";
    description = "A nixpkgs overlay function";
    descriptionClass = "noun";
    # NOTE: This check is not exhaustive, as there is no way
    # to check that the function takes two arguments, and
    # returns an attrset.
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
        description = "Nixpkgs overlay";
        default = self: super: { };
        defaultText = lib.literalExpression "self: super: { }";
      };
      output = mkOption { };
    };
  };

in
{
  options = {
    nixpkgs = lib.mkOption {
      type = nixpkgsSubmodule;
      description = ''
        Configuration of nixpkgs
      '';
      default.overlays = [ ];
    };
  };

  config = {
    perSystem = { lib, ... }: {
      config = {
        _module.args.pkgs = import ./.
          { inherit system; inherit (config.nixpkgs) overlays; };
      };
    };
  };
}
