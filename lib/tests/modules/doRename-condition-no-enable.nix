{ config, options, ... }:
{
  config = {
    result =
      assert config.services.foos == { };
      assert ! options.services.foo.bar.isDefined;
      true;
  };
}
