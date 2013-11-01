{ config, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/nova-image.nix" ];
}
