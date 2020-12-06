{ lib, ... }: {
  options.value = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
  };
}
