{ lib, ... }: {
  imports = [
    (lib.doRenames { from = ["old"]; to = ["new"]; })
  ];
  options = {
    new.foo = lib.mkOption {
      type = lib.types.int;
    };
  };
  config = {
    new.foo = lib.mkDefault 42;
    old.foo = lib.mkForce 1234;
  };
}
