{
  lib,
  config,
  options,
  ...
}:
{
  freeformType = with lib.types; attrsOf int;

  # Regular options
  options.bar = lib.mkOption {
    default = 1;
  };

  # This should be in _module.freeformConfig
  # With 'definitions' and 'type' in the corresponding options._module.freeformConfig
  config.foo = 42;

  imports = [
    {
      foo = 42;
    }
    {
      bar = 1;
    }
  ];

  options.result = lib.mkOption {
    default =
      assert config._module.freeformConfig == { foo = 42; };
      # option has the merged value
      assert options._module.freeformConfig.value == { foo = 42; };
      # option contains freeform definitions
      assert
        options._module.freeformConfig.definitions == [
          { foo = 42; }
          { foo = 42; }
        ];
      # The type should be inherited from freeformType
      assert options._module.freeformConfig.type.nestedTypes.elemType.name == "int";
      true;
  };
}
