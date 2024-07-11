{ lib, ... }:

let
  submod = { ... }: {
    options = {
      enable = lib.mkOption {
        default = false;
        example = true;
        type = lib.types.bool;
        description = ''
          Some descriptive text
        '';
      };
    };
  };
in

{
  options = {
    attrsOfSub = lib.mkOption {
      default = {};
      example = {};
      type = lib.types.attrsOf (lib.types.submodule [ submod ]);
      description = ''
        Some descriptive text
      '';
    };
  };
}
