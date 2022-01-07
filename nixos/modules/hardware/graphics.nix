{ config, lib, pkgs, ... }:

with lib;

let

  # Abbreviations.
  cfg = config.hardware.graphics;
  xorg = pkgs.xorg;


in

{

  imports = [
    (mkRenamedOptionModule [ "services" "xserver" "videoDrivers" ] [ "hardware" "graphics" "videoDrivers" ])
  ];



  ###### interface

  options = {

    hardware.graphics = {

      enable = mkOption {
        type = types.bool;
        default = config.services.xserver.enable;
        description = ''
          Whether to enable GPU support, whether for graphics like X or Wayland, or other purposes.
        '';
      };

      videoDrivers = mkOption {
        type = types.listOf types.str;
        default = [ "amdgpu" "radeon" "nouveau" "modesetting" "fbdev" ];
        example = [
          "nvidia" "nvidiaLegacy390" "nvidiaLegacy340" "nvidiaLegacy304"
          "amdgpu-pro"
        ];
        # TODO(@oxij): think how to easily add the rest, like those nvidia things
        relatedPackages = concatLists
          (mapAttrsToList (n: v:
            optional (hasPrefix "xf86video" n) {
              path  = [ "xorg" n ];
              title = removePrefix "xf86video" n;
            }) pkgs.xorg);
        description = ''
          The names of the video drivers the configuration
          supports. They will be tried in order until one that
          supports your card is found.
          Don't combine those with "incompatible" OpenGL implementations,
          e.g. free ones (mesa-based) with proprietary ones.

          For unfree "nvidia*", the supported GPU lists are on
          https://www.nvidia.com/object/unix.html
        '';
      };

    };

  };



  ###### implementation

  config = mkIf cfg.enable {


  };

  # uses relatedPackages
  meta.buildDocsInSandbox = false;
}
