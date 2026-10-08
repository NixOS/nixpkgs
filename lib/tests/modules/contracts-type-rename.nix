# The contract type `number` is renamed to `count`.
# A consumer of `number` still works, and the provider of `count` fulfills its request.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.contracts) count;
  intOption = mkOption {
    type = types.submodule {
      options.value = mkOption { type = types.int; };
    };
  };

  # The module that renames `number` to `count`.
  rename = {
    contracts =
      { ... }:
      {
        imports = [ (lib.mkRenamedOptionModule [ "number" ] [ "count" ]) ];
      };
  };
in
{
  imports = [
    lib.contract.module
    rename
  ];

  options = {
    services.increment = mkOption {
      default = count.providerRequests.increment;
      type = config.contractTypes.count.mkProviderType {
        fulfill =
          { value }:
          {
            value = value + 1;
          };
      };
    };

    wantedNames = mkOption {
      type = types.str;
      default = lib.concatStringsSep "," (lib.attrNames count.want);
    };
  };

  config = {
    contractTypes.count = {
      meta = {
        description = "A number.";
        maintainers = [ lib.maintainers.kiara ];
      };
      interface.options = {
        request = intOption;
        response = intOption;
      };
    };

    # A consumer of the old name, and a consumer of the new name.
    contracts.number.want.old.x.request.value = 5;
    contracts.count.want.new.x.request.value = 1;

    contracts.count.providers.increment = {
      module = options.services.increment;
      contract = [ ];
    };
    contracts.count.defaultProvider = config.contracts.count.providers.increment;
  };
}
