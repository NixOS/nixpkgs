{ config, lib, ... }: {
  imports = [
    {
      options.example1 = lib.mkOption {
        type = lib.types.configuration { };
      };
    }
    {
      options.example1 = lib.mkOption {
        type = lib.types.configuration { };
      };
    }
  ];
  options.result = lib.mkOption { type = lib.types.attrsOf lib.types.raw; };

  config = {
    result.example1 = config.example1;
    example1 = lib.evalModules {
      class = "exampleBarClass";
      modules = [ {
        options = {
          foo = lib.mkOption { type = lib.types.str; };
        };
        config = {
          foo = "bar";
        };
      } ];
    };
  };
}
