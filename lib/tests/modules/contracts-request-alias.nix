# A consumer sets a renamed `request` option by its old name.
# The provider gets only the new name.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.contracts) number;
  intOption = mkOption {
    type = types.submodule {
      options.value = mkOption { type = types.int; };
    };
  };
in
{
  imports = [ lib.contract.module ];

  options = {
    # Sets the old name.
    consumer = mkOption {
      default = {
        request.oldValue = 7;
      };
      type = config.contractTypes.number.mkContract { };
    };

    # Sets only the new name.
    newConsumer = mkOption {
      default = {
        request.value = 3;
      };
      type = config.contractTypes.number.mkContract { };
    };

    # The provider: adds 1 to each request.
    increment = mkOption {
      type = types.raw;
      default = lib.mapAttrsRecursiveCond (v: !(v ? request)) (_: entry: {
        response.value = entry.request.value + 1;
      }) number.providerRequests.increment;
    };

    providerRequestNames = mkOption {
      type = types.str;
      default = lib.concatStringsSep "," (lib.attrNames number.providerRequests.increment.app.x.request);
    };

    resultNames = mkOption {
      type = types.str;
      default = lib.concatStringsSep "," (lib.attrNames number.results.app.x);
    };
  };

  config = {
    contractTypes.number = {
      meta = {
        description = "A number.";
        maintainers = [ lib.maintainers.kiara ];
      };
      interface.options = {
        request = intOption;
        response = intOption;
      };
      requestAliases = [ (lib.mkRenamedOptionModule [ "oldValue" ] [ "value" ]) ];
    };

    contracts.number = {
      want.app.x.request.oldValue = 5;
      # A consumer forwards its `request` to `want`.
      want.forward.old = { inherit (config.consumer) request; };
      want.forward.new = { inherit (config.newConsumer) request; };
      providers.increment = {
        module = options.increment;
        contract = [ ];
      };
      defaultProvider = number.providers.increment;
    };
  };
}
