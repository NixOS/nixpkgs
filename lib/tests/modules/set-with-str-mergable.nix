{ config, ... }:
{
  imports = [
    {
      set = [
        "foo"
      ];
    }
    {
      set = [
        "bar"
      ];
    }
    {
      result =
        assert
          config.set == [
            "bar"
            "foo"
          ];
        true;
    }
  ];
}
