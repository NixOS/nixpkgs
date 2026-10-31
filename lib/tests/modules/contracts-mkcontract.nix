# `mkContract` adds the overrides to the options of the interface.
{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  intOption = mkOption {
    type = types.submodule {
      options.value = mkOption { type = types.int; };
    };
  };
in
{
  imports = [ lib.contract.module ];

  options = {
    consumer = mkOption {
      default = { };
      type = config.contractTypes.number.mkContract {
        request.value = {
          default = 42;
          readOnly = true;
        };
      };
    };

    # A contract type from `lib.contracts`.
    secret = mkOption {
      default = { };
      type = lib.contracts.fileSecrets.mkContract {
        request = {
          owner.default = "me";
          group.default = "me";
        };
        response.path.default = "/run/secret";
      };
    };

    secretSummary = mkOption {
      type = types.str;
      default = with config.secret; "${request.mode} ${request.owner} ${request.group} ${response.path}";
    };
  };

  config.contractTypes.number = {
    meta = {
      description = "A number.";
      maintainers = [ lib.maintainers.kiara ];
    };
    interface.options = {
      request = intOption;
      response = intOption;
    };
  };
}
