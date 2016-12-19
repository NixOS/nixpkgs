{ config, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/brightbox-image.nix" ];
}
