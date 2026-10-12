{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.expr = mkOption {
    type = types.record {
      wildcardType = types.raw;
      optional = {
        ofoo = lib.mkOption { type = types.raw; };
        obar = lib.mkOption { type = types.raw; };
        optional_seed = lib.mkOption { type = types.raw; };
        submodule = lib.mkOption {
          type = types.submodule {
            options.time = lib.mkOption {
              type = types.int;
              default = 42;
            };
          };
        };
      };
      required = {
        required_seed = lib.mkOption { type = types.raw; };
        rfoo = lib.mkOption {
          type = types.raw;
          default = 1;
          readOnly = true;
        };
        rbar = lib.mkOption { type = types.raw; };
      };
    };
  };
  config.expr = {
    submodule = {
      time = 100;
    };
    wildcard_seed = "bar"; # wildcard
    required_seed = "bar";
    optional_seed = "bar";
    # Test recursive references
    rfoo = "error"; # Is readOnly
    rbar = (config.expr.obar + "!"); # required -> optional
    obar = (config.expr.ofoo + "!"); # optional -> optional
    ofoo = (config.expr.required_seed + "!"); # optional -> required
  };

  options.result = mkOption { default = lib.deepSeq config.expr "ok"; };
}
