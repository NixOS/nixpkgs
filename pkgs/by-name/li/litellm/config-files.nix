# The inputs of `pkgs.configFiles`. `nixos/modules/services/misc/litellm.nix`
# imports this file by path.
{
  name = "litellm";
  relativeTo = "the directory that holds the configuration of LiteLLM";
  modules = [ ./config-module.nix ];
}
