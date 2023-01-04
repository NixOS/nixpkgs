{ lib, ... }:

{
  options = {
    value = lib.mkOption {
      type = with lib.types; let
        t = oneOf [ str (attrsOf t) ];
      in t // {
        description = "a recursive type";
      };
      description = "a value";
    };
  };
}
