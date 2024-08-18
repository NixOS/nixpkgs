{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.lubelogger;
in
{
  options = {
    services.lubelogger = {
      enable = mkEnableOption "Lubelogger, a self-hosted, open-source, web-based vehicle maintenance and fuel milage tracker";

      package = mkPackageOption pkgs "lubelogger" { };

      dataDir = mkOption {
        description = "Path to Lubelogger config and metadata inside of /var/lib.";
        default = "lubelogger";
        type = types.str;
      };

      port = mkOption {
        description = "The TCP port Lubelogger will listen on.";
        default = 5000;
        readOnly = true; # Lubelogger does not allow you to configure the port it runs on
        type = types.port;
      };

      user = mkOption {
        description = "User account under which Lubelogger runs.";
        default = "audiobookshelf";
        type = types.str;
      };

      group = mkOption {
        description = "Group under which Lubelogger runs.";
        default = "lubelogger";
        type = types.str;
      };

      openFirewall = mkOption {
        description = "Open ports in the firewall for the Lubelogger web interface.";
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lubelogger = {
      description = "Lubeloger is a self-hosted vehicle maintenance and fuel mileage tracker";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.DOTNET_CONTENTROOT = "/var/lib/${cfg.dataDir}";

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

    users.users = mkIf (cfg.user == "lubelogger") {
      lubelogger = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${cfg.dataDir}";
      };
    };

    users.groups = mkIf (cfg.group == "lubelogger") { lubelogger = { }; };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
