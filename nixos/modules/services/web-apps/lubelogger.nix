{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lubelogger;
in
{
  meta.maintainers = with lib.maintainers; [ lyndeno ];

  options = {
    services.lubelogger = {
      enable = lib.mkEnableOption "Lubelogger, a self-hosted, open-source, web-based vehicle maintenance and fuel milage tracker";

      package = lib.mkPackageOption pkgs "lubelogger" { };

      dataDir = lib.mkOption {
        description = "Path to Lubelogger config and metadata inside of /var/lib.";
        default = "lubelogger";
        type = lib.types.str;
      };

      port = lib.mkOption {
        description = "The TCP port Lubelogger will listen on.";
        default = 5000;
        type = lib.types.port;
      };

      user = lib.mkOption {
        description = "User account under which Lubelogger runs.";
        default = "lubelogger";
        type = lib.types.str;
      };

      group = lib.mkOption {
        description = "Group under which Lubelogger runs.";
        default = "lubelogger";
        type = lib.types.str;
      };

      openFirewall = lib.mkOption {
        description = "Open ports in the firewall for the Lubelogger web interface.";
        default = false;
        type = lib.types.bool;
      };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = with lib.types; attrsOf str; };
        default = { };
        example = {
          LUBELOGGER_ALLOWED_FILE_EXTENSIONS = "";
          LUBELOGGER_LOGO_URL = "";
        };
        description = ''
          Additional configuration for LubeLogger, see
          <https://docs.lubelogger.com/Environment%20Variables>
          for supported values.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.lubelogger = {
      description = "Lubelogger is a self-hosted vehicle maintenance and fuel mileage tracker";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        DOTNET_CONTENTROOT = "/var/lib/${cfg.dataDir}";
        Kestrel__Endpoints__Http__Url = "http://localhost:${cfg.port}";
      } // cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = cfg.dataDir;
        WorkingDirectory = "/var/lib/${cfg.dataDir}";
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";

        ExecStartPre = pkgs.writeShellScript "lubelogger-prestart" ''
          cd $STATE_DIRECTORY
          if [ ! -e .nixos-lubelogger-contentroot-copied ]; then
            cp -r ${cfg.package}/lib/lubelogger/* .
            chmod -R 744 .
            touch .nixos-lubelogger-contentroot-copied
          fi
        '';
      };
    };

    users.users = lib.mkIf (cfg.user == "lubelogger") {
      lubelogger = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${cfg.dataDir}";
      };
    };

    users.groups = lib.mkIf (cfg.group == "lubelogger") { lubelogger = { }; };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
