# Tests that using a renamed contract name emits a deprecation warning in config.warnings.
#
# mkRenamedOptionModule cannot be used for contracts.<name> because `contracts` is a single
# submodule-typed option — doRename cannot find or declare sub-options within it.
# Instead, a rename is implemented as a NixOS module that:
#   1. Defines the old contractType independently (same interface, separate declaration)
#   2. Adds a config.warnings entry when the old contract's `want` is non-empty
{
  lib,
  config,
  options,
  ...
}:
let
  sharedInterface = {
    request.value = lib.mkOption { type = lib.types.int; };
    result.value = lib.mkOption { type = lib.types.int; };
  };
in
{
  imports = [
    lib.contract.module
    # Rename warning: emits config.warnings when contracts.oldName is used.
    (
      { config, lib, ... }:
      {
        warnings = lib.optional (
          config.contracts.oldName.want != { }
        ) "The contract `oldName` has been renamed to `newName`. Please update your configuration.";
      }
    )
  ];

  # meta is a NixOS-level option; provide a stub so the contracts module's
  # `meta.buildDocsInSandbox = false` is accepted in this bare evalModules context.
  options.meta = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
  options.warnings = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };
  options.result = lib.mkOption {
    type = lib.types.str;
    default = "";
  };

  # Provider option for the deprecated contract: increments request value by 1.
  options.services.increment.oldName = lib.mkOption {
    default = config.contracts.oldName.requests;
    type = config.contractTypes.oldName.mkProviderType {
      fulfill =
        { value }:
        {
          value = value + 1;
        };
    };
  };

  config = {
    contractTypes.newName = {
      meta = {
        description = "New contract name (test).";
        maintainers = [ ];
      };
      interface = sharedInterface;
    };
    # Old contract type: same interface, declared independently to avoid self-reference.
    # (contractTypes.oldName = config.contractTypes.newName would cause infinite recursion
    # because config.contractTypes is built from all contractTypes definitions including oldName.)
    contractTypes.oldName = {
      meta = {
        description = "Deprecated: renamed to newName.";
        maintainers = [ ];
      };
      interface = sharedInterface;
    };

    # Consumer uses the old (renamed) contract name.
    contracts.oldName.want.consumer.instance.request.value = 5;

    # Provider wiring uses the GUI-discoverable `{ module, contract? }` shape.
    contracts.oldName.providers.increment.module = options.services.increment.oldName;
    contracts.oldName.defaultProvider = config.contracts.oldName.providers.increment;

    result = lib.concatStringsSep "%" config.warnings;
  };
}
