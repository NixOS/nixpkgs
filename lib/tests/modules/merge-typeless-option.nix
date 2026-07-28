{ ... }:

let
  typeless =
    { lib, ... }:

    {
      options.group = lib.mkOption { };
    };
  childOfTypeless =
    { lib, ... }:

    {
      options.group.enable = lib.mkEnableOption "nothing";
    };
in

{
  imports = [
    typeless
    childOfTypeless
  ];

  config.group.enable = false;
}
