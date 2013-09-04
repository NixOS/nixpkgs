{ config, pkgs, ... }:

with pkgs.lib;

let

  pcmciaUtils = pkgs.pcmciaUtils.passthru.function {
    inherit (config.hardware.pcmcia) firmware config;
  };

in


{
  ###### interface

  options = {

    hardware.pcmcia = {
      enable = mkOption {
        default = false;
        merge = mergeEnableOption;
        description = ''
          Enable this option to support PCMCIA card.
        '';
      };

      firmware = mkOption {
        default = [];
        merge = mergeListOption;
        description = ''
          List of firmware used to handle specific PCMCIA card.
        '';
      };

      config = mkOption {
        default = null;
        description = ''
          Path to the configuration file which map the memory, irq
          and ports used by the PCMCIA hardware.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf config.hardware.pcmcia.enable {

    boot.kernelModules = [ "pcmcia" ];

    services.udev.packages = [ pcmciaUtils ];

    environment.systemPackages = [ pcmciaUtils ];

  };

}
