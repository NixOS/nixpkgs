{ config, lib, pkgs, ... }:

let
  cfg = config.services.osmo-hlr;
in
{
  options = {
    services.osmo-hlr = {
      enable = lib.mkEnableOption (lib.mdDoc "OsmoHLR");
      package = lib.mkPackageOptionMD pkgs "osmo-hlr" { };
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
          osmo-hlr settings, for configuration options see the example on [osmocom.org](https://projects.osmocom.org/projects/osmo-hlr/repository/osmo-hlr/revisions/master/entry/doc/examples/osmo-hlr.cfg)
        '';
        example = lib.literalExpression ''
          log stderr
           logging filter all 1
           logging color 1
           logging print category 1
           logging print category-hex 0
           logging print level 1
           logging print file basename last
           logging print extended-timestamp 1
           logging level main notice
           logging level db notice
           logging level auc notice
           logging level ss notice
           logging level linp error
          line vty
           bind 127.0.0.1
          ctrl
           bind 127.0.0.1
          hlr
           gsup
            bind ip 127.0.0.1
           ussd route prefix *#100# internal own-msisdn
           ussd route prefix *#101# internal own-imsi
        '';
      };
    };
  };

  config =
    let flagsStr = lib.escapeShellArgs cfg.flags;
    in lib.mkIf cfg.enable {
      environment.etc."osmocom/osmo-hlr.cfg".source = pkgs.writeTextFile {
        name = "osmo-hlr.cfg";
        text = cfg.settings;
      };
      systemd.services = {
        osmo-hlr = {
          wants = [ "network.target" ];
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          description = "OsmoHLR";
          documentation=[ "https://osmocom.org/projects/osmo-hlr/wiki/OsmoHLR" ];
          serviceConfig = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 2;
            DynamicUser = true;
            StateDirectory="osmocom";
            WorkingDirectory="%S/osmocom";
            ExecStart = "${cfg.package}/bin/osmo-hlr -c /etc/osmocom/osmo-hlr.cfg ${flagsStr}";
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
