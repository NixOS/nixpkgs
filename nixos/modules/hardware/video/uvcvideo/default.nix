
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.uvcvideo;

  uvcdynctrl-udev-rules = packages: pkgs.callPackage ./uvcdynctrl-udev-rules.nix {
    drivers = packages;
    udevDebug = false;
  };

in

{

  options = {
    services.uvcvideo.dynctrl = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable {command}`uvcvideo` dynamic controls.

          Note that enabling this brings the {command}`uvcdynctrl` tool
          into your environment and register all dynamic controls from
          specified {command}`packages` to the {command}`uvcvideo` driver.
        '';
      };

      packages = mkOption {
        type = types.listOf types.path;
        example = literalExpression "[ pkgs.tiscamera ]";
        description = lib.mdDoc ''
          List of packages containing {command}`uvcvideo` dynamic controls
          rules. All files found in
          {file}`«pkg»/share/uvcdynctrl/data`
          will be included.

          Note that these will serve as input to the {command}`libwebcam`
          package which through its own {command}`udev` rule will register
          the dynamic controls from specified packages to the {command}`uvcvideo`
          driver.
        '';
        apply = map getBin;
      };
    };
  };

  config = mkIf cfg.dynctrl.enable {

    services.udev.packages = [
      (uvcdynctrl-udev-rules cfg.dynctrl.packages)
    ];

    environment.systemPackages = [
      pkgs.libwebcam
    ];

  };
}
