{ lib, ... }:

let
  newOption =
    { lib, ... }:
    {
      options.group-b.enable = lib.mkEnableOption "nothing";
    };
in

{
  imports = [
    newOption
    (lib.mkRenamedOptionModule [ "group-a" "enable" ] [ "group-b" "enable" ])
  ];

  disabledModules = [
    { key = "lib/modules.nix#doRename-group-a.enable-to-group-b.enable"; }
  ];

  config.group-a.enable = true;
}
