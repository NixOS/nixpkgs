{ lib, config, ... }: {
  imports = [
    # doRename sets warnings, so this has to be imported.
    ./dummy-warnings-module.nix
    (lib.doRename { from = ["a" "b"]; to = ["c" "d" "e"]; warn = true; use = x: x; visible = true; })
  ];
  options = {
    c.d.e = lib.mkOption {};
    result = lib.mkOption {};
  };
  config = {
    a.b = 1234;
    result = lib.concatStringsSep "%" config.warnings;
  };
}
