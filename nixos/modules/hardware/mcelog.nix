{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {

    hardware.mcelog = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable the Machine Check Exception logger.
        '';
      };
    };

  };

  config = lib.mkIf config.hardware.mcelog.enable {
    systemd = {
      packages = [ pkgs.mcelog ];

      services.mcelog = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ProtectHome = true;
          PrivateNetwork = true;
          PrivateTmp = true;
        };
      };
    };
  };
}
