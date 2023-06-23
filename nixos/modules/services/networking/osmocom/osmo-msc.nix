{ config, lib, pkgs, ... }:

let
  cfg = config.services.osmo-msc;
in
{
  options = {
    services.osmo-msc = {
      enable = lib.mkEnableOption (lib.mdDoc "OsmoMSC");
      package = lib.mkPackageOptionMD pkgs "osmo-msc" { };
      flags = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        example = [ "--timestamp" ];
        description = lib.mdDoc ''
          Flags to append to the program call
          '';
      };
      settings = lib.mkOption {
        type = lib.types.lines;
        default = { };
        description = lib.mdDoc ''
          osmo-msc settings, for configuration options see the example on [osmocom.org](https://osmocom.org/projects/osmomsc/repository/osmo-msc/revisions/master/entry/doc/examples/osmo-msc/osmo-msc.cfg)
        '';
        example = lib.literalExpression ''
          network
           network country code 901
           mobile network code 70
          msc
           mgw remote-ip 192.168.0.9
           # For nano3G:
           iu rab-assign-addr-enc x213

          log stderr
           logging filter all 1
           logging print extended-timestamp 1
           logging print category 1
           logging print category-hex 0
           logging print level 1
           logging print file basename last
           logging level set-all info
        '';
      };
    };
  };

  config =
    let flagsStr = lib.escapeShellArgs cfg.flags;
    in lib.mkIf cfg.enable {
      environment.etc."osmocom/osmo-msc.cfg".source = pkgs.writeTextFile {
        name = "osmo-msc.cfg";
        text = cfg.settings;
      };
      systemd.services = {
        osmo-msc = {
          wants = [ "network.target" ];
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          description = "OsmoMSC";
          documentation=[ "https://osmocom.org/projects/osmo-msc/wiki/OsmoMSC" ];
          serviceConfig = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 2;
            DynamicUser = true;
            StateDirectory="osmocom";
            WorkingDirectory="%S/osmocom";
            ExecStart = "${cfg.package}/bin/osmo-msc -c /etc/osmocom/osmo-msc.cfg ${flagsStr}";
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectHostname = true;
            ProtectClock = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
          };
        };
      };
    };
}
