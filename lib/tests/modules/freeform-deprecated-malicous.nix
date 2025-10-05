{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.either = mkOption {
    type = types.submodule ({
      freeformType = (types.either types.int types.int);
    });
  };

  options.eitherBehindNullor = mkOption {
    type = types.submodule ({
      freeformType = types.nullOr (types.either types.int types.int);
    });
  };

  options.oneOf = mkOption {
    type = types.submodule ({
      freeformType = (
        types.oneOf [
          types.int
          types.int
        ]
      );
    });
  };

  options.number = mkOption {
    type = types.submodule ({
      freeformType = (types.number); # either int float
    });
  };
}
