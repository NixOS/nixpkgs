{ config, pkgs, ... }:

{
  imports = [ ./general.nix ];

   # modesetting driver leads to freezes with newer kernel at the moment (> 4.4)
   services.xserver.videoDrivers = [ "intel" ];

   services.xserver.libinput.enable = true;
}
