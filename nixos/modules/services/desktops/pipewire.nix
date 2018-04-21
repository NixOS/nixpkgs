# pipewire service.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.pipewire = {
      enable = mkEnableOption "pipewire service";
    };
  };


  ###### implementation
  config = mkIf config.services.pipewire.enable {
    environment.systemPackages = [ pkgs.pipewire ];

    systemd.packages = [ pkgs.pipewire ];
  };

  meta.maintainers = with lib.maintainers; [ jtojnar ];
}
