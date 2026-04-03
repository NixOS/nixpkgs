# Tests that a renamed contract request option:
# - still forwards the value correctly (old name → new name)
# - emits a lib.warn on stderr
{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (config.contractTypes.versioned) mkProviderType;
in
{
  imports = [ lib.contract.module ];

  # meta is a NixOS-level option; provide a stub so the contracts module's
  # `meta.buildDocsInSandbox = false` is accepted in this bare evalModules context.
  options.meta = mkOption {
    type = types.attrs;
    default = { };
  };

  config.contractTypes.versioned = {
    meta = {
      description = "A test contract to verify rename warning behavior.";
      maintainers = [ ];
    };
    interface = {
      request.newValue = mkOption {
        description = "Input value (renamed from oldValue).";
        type = types.int;
      };
      result.value = mkOption {
        description = "Output value.";
        type = types.int;
      };
      extraImports.request = [
        (
          { config, options, ... }:
          {
            options.oldValue = mkOption {
              description = "Deprecated alias for newValue.";
              type = types.int;
              visible = false;
              apply = lib.warn "The option `request.oldValue` has been renamed to `request.newValue`. Please update your configuration.";
            };
            config = lib.mkIf options.oldValue.isDefined {
              newValue = lib.mkDefault config.oldValue;
            };
          }
        )
      ];
    };
  };

  options.services.increment.versioned = mkOption {
    default = config.contracts.versioned.requests;
    type = mkProviderType {
      fulfill =
        { newValue }:
        {
          value = newValue + 1;
        };
    };
  };

  config = {
    # Consumer uses the old (renamed) option name.
    contracts.versioned.want.consumer.instance.request.oldValue = 5;

    contracts.versioned.providers.increment = config.services.increment.versioned;
    contracts.versioned.defaultProvider = config.contracts.versioned.providers.increment;
  };
}
