{ lib, ... }:

{
  options.set = lib.mkOption {
    default = { };
    example = { a = 1; };
    type = lib.types.attrsOf lib.types.int;
    description = ''
      Some descriptive text
    '';
  };
}
