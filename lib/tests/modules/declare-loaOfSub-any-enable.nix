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
    loaOfSub = lib.mkOption {
      default = {};
      example = {};
      type = lib.types.loaOf (lib.types.submodule [ submod ]);
      description = ''
        Some descriptive text
      '';
    };
  };
}
