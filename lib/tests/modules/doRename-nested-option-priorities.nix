{ lib, ... }: {
  imports = [
    (lib.doRename { from = ["old"]; to = ["new"]; warn = true; use = x: x; visible = true; })
  ];
  options = {
    new.foo = lib.mkOption {
      type = lib.types.int;
    };
  };
  config = {
    old.foo = lib.mkDefault 1234;
  };
}
