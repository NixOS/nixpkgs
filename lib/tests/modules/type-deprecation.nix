{ lib, ... }: {

  options.simple = lib.mkOption {
    type = lib.mkOptionType {
      name = "simple";
      deprecationMessage = "simple shall not be used";
    };
    default = throw "";
  };

  options.infinite = lib.mkOption {
    type =
      let
        t = lib.mkOptionType {
          name = "infinite";
          deprecationMessage = "infinite shall not be used";
        };
        r = lib.types.either t (lib.types.attrsOf r);
      in r;
    default = throw "";
  };

  options.nested = lib.mkOption {
    type =
      let
        left = lib.mkOptionType {
          name = "left";
          deprecationMessage = "left shall not be used";
        };
        right = lib.mkOptionType {
          name = "right";
          deprecationMessage = "right shall not be used";
        };
      in lib.types.either left right;

    default = throw "";
  };

}
