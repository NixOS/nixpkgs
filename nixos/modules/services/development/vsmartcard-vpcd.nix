{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.vsmartcard-vpcd;

in
{

  options.services.vsmartcard-vpcd = {
    enable = lib.mkEnableOption "Virtual smart card driver.";

    port = lib.mkOption {
      type = lib.types.port;
      default = 35963;
      description = ''
        Port number vpcd will be listening on.
      '';
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "/dev/null";
      description = ''
        Hostname of a waiting vpicc server vpcd will be connecting to. Use /dev/null for listening mode.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.readerConfigs = [
      ''
        FRIENDLYNAME "Virtual PCD"
        DEVICENAME   ${cfg.hostname}:0x${lib.toHexString cfg.port}
        LIBPATH      ${pkgs.vsmartcard-vpcd}/var/lib/pcsc/drivers/serial/libifdvpcd.so
        CHANNELID    0x${lib.toHexString cfg.port}
      ''
    ];

    environment.systemPackages = [ pkgs.vsmartcard-vpcd ];
  };

  meta.maintainers = with lib.maintainers; [ stargate01 ];
}
