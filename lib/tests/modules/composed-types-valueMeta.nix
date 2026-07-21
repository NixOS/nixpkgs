{ lib, ... }:
let
  inherit (lib) types mkOption;

  attrsOfModule = mkOption {
    type = types.attrsOf (
      types.submodule {
        options.bar = mkOption {
          type = types.int;
        };
      }
    );
  };

  listOfModule = mkOption {
    type = types.listOf (
      types.submodule {
        options.bar = mkOption {
          type = types.int;
        };
      }
    );
  };

in
{
  imports = [
    #  Module A
    {
      options.attrsOfModule = attrsOfModule;
      options.mergedAttrsOfModule = attrsOfModule;
      options.listOfModule = listOfModule;
      options.mergedListOfModule = listOfModule;
    }
    # Module B
    {
      options.mergedAttrsOfModule = attrsOfModule;
      options.mergedListOfModule = listOfModule;
    }
    # Values
    # It is important that the value is defined in a separate module
    # Without valueMeta the actual value and sub-options wouldn't be accessible via:
    # options.attrsOfModule.type.getSubOptions
    {
      attrsOfModule = {
        foo.bar = 42;
      };
      mergedAttrsOfModule = {
        foo.bar = 42;
      };
    }
    (
      { options, ... }:
      {
        config.listOfModule = [
          {
            bar = 42;
          }
        ];
        config.mergedListOfModule = [
          {
            bar = 42;
          }
        ];
        # Result options to expose the list module to bash as plain attribute path
        options.listResult = mkOption {
          default = (builtins.head options.listOfModule.valueMeta.list).configuration.options.bar.value;
        };
        options.mergedListResult = mkOption {
          default = (builtins.head options.mergedListOfModule.valueMeta.list).configuration.options.bar.value;
        };
      }
    )
  ];
}
