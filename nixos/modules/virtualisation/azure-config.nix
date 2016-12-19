{ config, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/azure-image.nix" ];
}
