{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mame;
  mame = "mame${lib.optionalString pkgs.stdenv.is64bit "64"}";
in
{
  options = {
    services.mame = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to setup TUN/TAP Ethernet interface for MAME emulator.
        '';
      };
      user = mkOption {
        type = types.str;
        description = ''
          User from which you run MAME binary.
        '';
      };
      hostAddr = mkOption {
        type = types.str;
        description = ''
          IP address of the host system. Usually an address of the main network
          adapter or the adapter through which you get an internet connection.
        '';
        example = "192.168.31.156";
      };
      emuAddr = mkOption {
        type = types.str;
        description = ''
          IP address of the guest system. The same you set inside guest OS under
          MAME. Should be on the same subnet as <option>services.mame.hostAddr</option>.
        '';
        example = "192.168.31.155";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mame ];

    security.wrappers."${mame}" = {
      source = "${pkgs.mame}/bin/${mame}";
      capabilities = "cap_net_admin,cap_net_raw+eip";
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

  meta.maintainers = with lib.maintainers; [ ];
}
