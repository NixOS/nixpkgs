{ lib, ... }:
{
  imports = [
    {
      options.foo = lib.mkOption {
        type = lib.types.str;
      };
    }
    {
      options.foo = lib.mkOption {
        type = lib.types.str.extend (
          final: prev: {
            check = x: prev.check x && lib.strings.hasPrefix "start" x;
          }
        );
      };
    }
  ];

  config.foo = "wrong start";
}
