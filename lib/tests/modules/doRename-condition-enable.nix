{ config, ... }:
{
  config = {
    services.foo.enable = true;
    services.foo.bar = "baz";
    result =
      assert
        config.services.foos == {
          "" = {
            bar = "baz";
          };
        };
      true;
  };
}
