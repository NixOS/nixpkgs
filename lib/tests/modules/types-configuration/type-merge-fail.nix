{ config, lib, ... }: {
  imports = [
    {
      options.example1 = lib.mkOption {
        type = lib.types.configuration { class = "classFooExample"; };
      };
    }
    {
      options.example1 = lib.mkOption {
        type = lib.types.configuration { class = "classBarExample"; };
      };
    }

    {
      options.example2 = lib.mkOption {
        type = lib.types.configuration { class = "classFooExample"; };
      };
    }

  ];
  options.result = lib.mkOption { type = lib.types.attrsOf lib.types.raw; };

  config = {
    result.example1 = config.example1;
    example1 = lib.evalModules { modules = [ ]; };

    result.example2 = config.example2;
    example2 = lib.evalModules { modules = [ ]; class = "classBarExample"; };
  };
}
