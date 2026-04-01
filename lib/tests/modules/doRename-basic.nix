{ lib, ... }:
{
  imports = [
    (lib.doRename {
      from = [
        "a"
        "b"
      ];
      to = [
        "c"
        "d"
        "e"
      ];
      warn = true;
      use = x: x;
      visible = true;
    })
  ];
  options = {
    c.d.e = lib.mkOption { };
  };
  config = {
    a.b = 1234;
  };
}
