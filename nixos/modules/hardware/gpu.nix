{ config, lib, pkgs, ... }:

with lib;

let

  # Abbreviations.
  cfg = config.hardware.gpu;

in {

  options.hardware.gpu = {
    enable = mkEnableOption (lib.mdDoc "Enable hardware drivers");

    drivers = mkOption {
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

  config = mkIf cfg.enable {

    hardware.drivers.enable = true;

  };

}

