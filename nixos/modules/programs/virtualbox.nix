let
  msg = "Importing <nixpkgs/nixos/modules/programs/virtualbox.nix> is "
      + "deprecated, please use `services.virtualboxHost.enable = true' "
      + "instead.";
in {
  config.warnings = [ msg ];
  config.services.virtualboxHost.enable = true;
}
