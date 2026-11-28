# The inputs of `pkgs.configFiles`. `nixos/modules/services/hardware/lact.nix`
# imports this file by path.
{
  name = "lact";
  moduleFiles = [ ./config-module.nix ];
}
