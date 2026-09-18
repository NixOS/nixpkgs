# The inputs of `pkgs.configFiles`. `nixos/modules/services/misc/litellm.nix`
# imports this file by path.
{
  name = "litellm";
  modules = [ ./config-module.nix ];
}
