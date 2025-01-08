{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.komga;

  settingsFormat = pkgs.formats.yaml { };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "services"
        "komga"
        "port"
      ]
      [
        "services"
        "komga"
        "settings"
        "server"
        "port"
      ]
    )
  ];

  options = {
    services.komga = {
      enable = lib.mkEnableOption "Komga, a free and open source comics/mangas media server";

      user = lib.mkOption {
        type = lib.types.str;
        default = "komga";
        description = "User account under which Komga runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "komga";
        description = "Group under which Komga runs.";
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/komga";
        description = "State and configuration directory Komga will use.";
      };

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        default = { };
        defaultText = lib.literalExpression ''
          {
            server.port = 8080;
          }
        '';
        description = ''
          Komga configuration.

          See [documentation](https://komga.org/docs/installation/configuration).
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the firewall for the port in {option}`services.komga.settings.server.port`.";
      };
    };
  };

  config =
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = (cfg.settings.komga.config-dir or cfg.stateDir) == cfg.stateDir;
          message = "You must use the `services.komga.stateDir` option to properly configure `komga.config-dir`.";
        }
      ];

      services.komga.settings = {
        server.port = lib.mkDefault 8080;
      };

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

      users.groups = lib.mkIf (cfg.group == "komga") { komga = { }; };

      users.users = lib.mkIf (cfg.user == "komga") {
        komga = {
          group = cfg.group;
          home = cfg.stateDir;
          description = "Komga Daemon user";
          isSystemUser = true;
        };
      };

      systemd.tmpfiles.settings."10-komga" = {
        ${cfg.stateDir}.d = {
          inherit (cfg) user group;
        };
        "${cfg.stateDir}/application.yml"."L+" = {
          argument = builtins.toString (settingsFormat.generate "application.yml" cfg.settings);
        };
      };

      systemd.services.komga = {
        environment = {
          KOMGA_CONFIGDIR = cfg.stateDir;
        };

        description = "Komga is a free and open source comics/mangas media server";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;

          Type = "simple";
          Restart = "on-failure";
          ExecStart = lib.getExe pkgs.komga;

          StateDirectory = lib.mkIf (cfg.stateDir == "/var/lib/komga") "komga";

          RemoveIPC = true;
          NoNewPrivileges = true;
          CapabilityBoundingSet = "";
          SystemCallFilter = [ "@system-service" ];
          ProtectSystem = "full";
          PrivateTmp = true;
          ProtectProc = "invisible";
          ProtectClock = true;
          ProcSubset = "pid";
          PrivateUsers = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          LockPersonality = true;
          RestrictNamespaces = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          SystemCallArchitectures = "native";
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ govanify ];
}
