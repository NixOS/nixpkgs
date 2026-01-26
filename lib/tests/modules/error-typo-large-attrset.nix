{ lib, ... }:

let
  inherit (lib) mkOption concatMapAttrs;

  ten = {
    a = null;
    b = null;
    c = null;
    d = null;
    e = null;
    f = null;
    g = null;
    h = null;
    i = null;
    j = null;
  };

  # Generate 1000 options (10 * 10 * 10)
  generatedOptions = concatMapAttrs (
    k1: _:
    concatMapAttrs (
      k2: _:
      concatMapAttrs (k3: _: {
        "${k1}${k2}${k3}" = mkOption {
          type = lib.types.bool;
          default = false;
        };
      }) ten
    ) ten
  ) ten;

  # Add some sensible options that are close to our typo
  sensibleOptions = {
    enable = mkOption {
      type = lib.types.bool;
      default = false;
    };
    enabled = mkOption {
      type = lib.types.bool;
      default = false;
    };
    disable = mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
in
{
  options = generatedOptions // sensibleOptions;

  config = {
    # Typo: "enble" is distance 1 from "enable"
    enble = true;
  };
}
