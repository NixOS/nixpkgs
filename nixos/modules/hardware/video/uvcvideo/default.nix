{ config, lib, pkgs, ... }:
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

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable {command}`uvcvideo` dynamic controls.

          Note that enabling this brings the {command}`uvcdynctrl` tool
          into your environment and register all dynamic controls from
          specified {command}`packages` to the {command}`uvcvideo` driver.
        '';
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        example = lib.literalExpression "[ pkgs.tiscamera ]";
        description = ''
          List of packages containing {command}`uvcvideo` dynamic controls
          rules. All files found in
          {file}`«pkg»/share/uvcdynctrl/data`
          will be included.

          Note that these will serve as input to the {command}`libwebcam`
          package which through its own {command}`udev` rule will register
          the dynamic controls from specified packages to the {command}`uvcvideo`
          driver.
        '';
        apply = map lib.getBin;
      };
    };
  };

  config = lib.mkIf cfg.dynctrl.enable {

    services.udev.packages = [
      (uvcdynctrl-udev-rules cfg.dynctrl.packages)
    ];

    environment.systemPackages = [
      pkgs.libwebcam
    ];

  };
}
