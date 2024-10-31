{ lib, config, ... }: {
  imports = [
    (lib.doRename { from = ["a" "b"]; to = ["c" "d" "e"]; warn = true; use = x: x; visible = true; })
  ];
  options = {
    warnings = lib.mkOption { type = lib.types.listOf lib.types.str; };
    c.d.e = lib.mkOption {};
    result = lib.mkOption {};
  };
  config = {
    a.b = 1234;
    result = lib.concatStringsSep "%" config.warnings;
  };
}
