{ config, lib, ... }:
{
  config = {
    services.foos."".bar = "baz";
    result =
      assert config.services.foos == { "" = { bar = "baz"; }; };
      assert config.services.foo.bar == "baz";
      true;
  };
}
