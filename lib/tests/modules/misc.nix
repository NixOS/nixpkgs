{ config, lib, options, ... }:

{
  options = {
    result = lib.mkOption { };
  };

  config.result =
    assert options._module.args.loc == [ "_module" "args" ];
    assert lib.showOption options._module.args.loc == "_module.args";
    assert lib.showOptionParent options._module.args.loc 1 == "_module";
    assert lib.showOptionParent options._module.args.loc 2 == "";
    assert lib.showOptionParent options._module.args.loc 3 == "";
    "ok";

}
