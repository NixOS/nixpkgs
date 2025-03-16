{ lib, custom, ... }: {
  options.result = lib.mkOption {};
  config._module.args.custom = throw "gotcha123";
  config.result = custom;
}
