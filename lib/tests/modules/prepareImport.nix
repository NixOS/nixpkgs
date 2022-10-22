{ config, lib, ... }: {
  options.result = lib.mkOption { };
  config.result = (lib.evalModules {
    specialArgs.prepareImport = x: x.testModules.default or x;
    modules = [
      {
        testModules.default = {
          config = {
            v = "ok";
          };
        };
      }
      {
        imports = [
          {
            testModules.default = {
              options.v = lib.mkOption { };
            };
          }
        ];
      }
    ];
  }).config.v;
}
