{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {
    services.asusd = {
      enable = mkOption {
        description = ''
          Use asusd to control the lighting, fan curve, GPU mode and more
          on supported Asus laptops.
        '';
        type = types.bool;
        default = false;
      };
      enable-power-profiles-daemon = mkOption {
        description = ''
          Enable integration with power-profiles-daemon, which is necessary
          for asusctl's 'profile' subcommand.
        '';
        type = types.bool;
        default = true;
      };
    };
  };

  ###### implementation

  config = mkIf config.services.asusd.enable (mkMerge [
    {
      services.supergfxd.enable = true;
      services.power-profiles-daemon.enable = true;
      environment.systemPackages = with pkgs; [ asusctl ];
      services.dbus.packages = with pkgs; [ asusctl ];
      services.udev.packages = with pkgs; [ asusctl ];
      systemd.packages = with pkgs; [ asusctl ];
    }
    (mkIf config.services.asusd.enable-power-profiles-daemon {
      services.power-profiles-daemon.enable = true;
      systemd.services.power-profiles-daemon = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
      };
    })
  ]);
}
