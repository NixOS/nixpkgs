{ lib, ... }:

{
  options.set = lib.mkOption {
    example = {
      a = 1;
    };
    type = lib.types.attrsOf lib.types.int;
    description = ''
      Some descriptive text
    '';
  };
}
