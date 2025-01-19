{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mame;
  mame = "mame${lib.optionalString pkgs.stdenv.hostPlatform.is64bit "64"}";
in
{
  options = {
    services.mame = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to setup TUN/TAP Ethernet interface for MAME emulator.
        '';
      };
      user = lib.mkOption {
        type = lib.types.str;
        description = ''
          User from which you run MAME binary.
        '';
      };
      hostAddr = lib.mkOption {
        type = lib.types.str;
        description = ''
          IP address of the host system. Usually an address of the main network
          adapter or the adapter through which you get an internet connection.
        '';
        example = "192.168.31.156";
      };
      emuAddr = lib.mkOption {
        type = lib.types.str;
        description = ''
          IP address of the guest system. The same you set inside guest OS under
          MAME. Should be on the same subnet as {option}`services.mame.hostAddr`.
        '';
        example = "192.168.31.155";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mame ];

    security.wrappers."${mame}" = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin,cap_net_raw+eip";
      source = "${pkgs.mame}/bin/${mame}";
    };

    systemd.services.mame = {
      description = "MAME TUN/TAP Ethernet interface";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.iproute2 ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.mame}/bin/taputil.sh -c ${cfg.user} ${cfg.emuAddr} ${cfg.hostAddr} -";
        ExecStop = "${pkgs.mame}/bin/taputil.sh -d ${cfg.user}";
      };
    };
  };

  meta.maintainers = [ ];
}
