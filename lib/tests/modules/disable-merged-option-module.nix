{ lib, ... }:

let
  newOption =
    { lib, ... }:

    {
      options.new-enable = lib.mkEnableOption "nothing";
    };

  mergeOptions =
    lib.mkMergedOptionModule
      [
        [ "old-enable-a" ]
        [ "old-enable-b" ]
      ]
      [ "new-enable" ]
      (config: config.old-enable-a == true && config.old-enable-b == true);
in

{
  imports = [
    # mkMergedOptionModule would set warnings, so this needs to be imported
    ./dummy-warnings-module.nix
    newOption
    mergeOptions
  ];

  disabledModules = [
    { key = "lib/modules.nix#mkMergedOptionModule-old-enable-a-old-enable-b-to-new-enable"; }
  ];

  config.old-enable-a = true;
}
