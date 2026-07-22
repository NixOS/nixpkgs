# Tests that mkContract applies request option overrides correctly.
# `mkContract { request = { value.default = 42; }; }` must propagate the
# default through extendSubmodule to the generated option type.
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  imports = [ ./contracts-arithmetic-contract.nix ];

  options = {
    consumer.myOpt = mkOption {
      default = { };
      type = config.contractDefinitions.arithmetic.mkContract {
        request = {
          value.default = 42;
        };
      };
    };
    result = mkOption {
      type = types.int;
    };
  };

  config.result = config.consumer.myOpt.request.value;
}
