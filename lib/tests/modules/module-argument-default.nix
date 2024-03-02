{ a ? false, lib, ... }: {
  options = {
    result = lib.mkOption {};
  };
  config = {
    _module.args.a = true;
    result = a;
  };
}
