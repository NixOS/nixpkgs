{ lib, ... }:

let
  optionModule =
    { lib, ... }:

    {
      options.group.enable = lib.mkEnableOption "nothing";
    };
in

{
  imports = [
    (lib.mkRemovedOptionModule [ "group" ] "This message should never show")
    optionModule
  ];

  disabledModules = [
    { key = "lib/modules.nix#mkRemovedOptionModule-group"; }
  ];

  config.group.enable = true;
}
