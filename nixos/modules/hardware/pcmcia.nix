{
  config,
  lib,
  pkgs,
  ...
}:
let
  pcmciaUtils = pkgs.pcmciaUtils.overrideAttrs {
    inherit (config.hardware.pcmcia) firmware config;
  };
in

{
  ###### interface
  options = {

    hardware.pcmcia = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable this option to support PCMCIA card.
        '';
      };

      firmware = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          List of firmware used to handle specific PCMCIA card.
        '';
      };

      config = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = ''
          Path to the configuration file which maps the memory, IRQs
          and ports used by the PCMCIA hardware.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf config.hardware.pcmcia.enable {

    boot.kernelModules = [ "pcmcia" ];

    services.udev.packages = [ pcmciaUtils ];

    environment.systemPackages = [ pcmciaUtils ];

  };

}
