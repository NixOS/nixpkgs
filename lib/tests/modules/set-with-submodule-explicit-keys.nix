# Merge partially defined submodules by key
{ config, lib, ... }:
{
  imports = [
    {
      set = [
        # Partial submodule, can evaluate, because we set key explizitly,
        # the default of the module would throw
        {
          key = "A";
          foo = "foo";
        }
      ];
    }
    {
      set = [
        {
          key = "A";
          bar = "bar";
        }
      ];
    }
    {
      set = [
        {
          key = "B";
          foo = "foo";
          bar = "bar";
        }
      ];
    }
    # Merge remove evaluates lazy
    {
      set = lib.types.setRemove [
        {
          key = "B";
          foo = "foo";
        }
      ];
    }
    {
      result =
        assert
          config.set == [
            {
              foo = "foo";
              bar = "bar";
              key = "A";
            }
          ];
        true;
    }
  ];
}
