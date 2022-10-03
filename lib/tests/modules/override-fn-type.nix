{ lib, config, ... }: with lib; {
  options.packageOverrides = mkOption {
    default = const {};
    type = types.overrideFnType;
  };
  options.result = mkOption {
    type = types.attrs;
  };
  config = mkMerge [
    {
      packageOverrides = pkgs: {
        test = pkgs.num + 1;
      };
    }
    {
      packageOverrides = pkgs: {
        test2 = pkgs.test + 1;
      };
    }
    {
      packageOverrides = mkAfter (pkgs: {
        test3 = 1;
      });
    }
    {
      packageOverrides = pkgs: {
        test3 = 2;
      };
    }
    {
      result = config.packageOverrides { num = 23; };
    }
  ];
}
