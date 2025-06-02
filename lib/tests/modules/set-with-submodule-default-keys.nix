# Merge submodules by their individual key
{ config, lib, ... }:
{
  imports = [
    {
      set = [
        {
          bar = "bar";
          foo = "foo";
          # -> key = "foobar";
        }
      ];
    }
    {
      set = [
        {
          foo = "foo";
          bar = "bar";
          # -> key = "foobar";
        }
        {
          key = "xx";
        }
      ];
    }
    {
      set = lib.types.setRemove [
        {
          foo = "x";
          bar = "x";
          # -> remove key = "xx";
        }
      ];
    }
    {
      result =
        assert
          config.set == [
            {
              foo = "foofoo";
              bar = "barbar";
              key = "foofoobarbar";
            }
          ];
        true;
    }
  ];
}
