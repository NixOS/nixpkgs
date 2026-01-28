{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.services.kapowarr;
in
{
  options = {
    services.kapowarr = {
      enable = mkEnableOption "Kapowarr is a software to build and manage a comic book library, fitting in the *arr suite of software.";

      package = mkPackageOption pkgs "kapowarr" { };

      host = mkOption {
        description = ''
          The host Kapowarr WebUI will listen on.
        '';
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = ''
          The TCP port Kapowarr WebUI will listen on.
        '';
        default = "5656";
        type = types.str;
      };

      databaseDir = mkOption {
        description = ''
          The folder in which the database will be stored or in which a database is for Kapowarr to use
        '';
        default = "/var/lib/kapowarr";
        example = "/home/myuser/.local/share/kapowarr";
        type = types.str;
      };

      tempdownloadDir = mkOption {
        description = ''
          The folder that direct downloads temporarily get downloaded to before being moved to the correct location
        '';
        default = "/var/lib/kapowarr/temp_downloads";
        example = "/home/myuser/.local/share/kapowarr/temp_downloads";
        type = types.str;
      };

      logDir = mkOption {
        description = ''
          The folder in which the logs from Kapowarr will be stored
        '';
        default = "/var/lib/kapowarr/logs";
        example = "/home/myuser/.local/share/kapowarr/logs";
        type = types.str;
      };

      logName = mkOption {
        description = ''
          The filename of the file in which the logs from Kapowarr will be stored
        '';
        default = "Kapowarr.log";
        example = "my_kapowarr_logs.log";
        type = types.str;
      };

      baseUrl = mkOption {
        description = ''
          For reverse proxy support, makes kapower listen on http://host:port/baseurl.
        '';
        default = "";
        example = "kapowarr becomes http://0.0.0.0:5656/kapowarr";
        type = types.str;
      };

      user = mkOption {
        description = "User account under which Kapowarr runs.";
        default = "kapowarr";
        type = types.str;
      };

      group = mkOption {
        description = "Group under which Kapowarr runs.";
        default = "kapowarr";
        type = types.str;
      };

      openFirewall = mkOption {
        description = "Open port in the firewall for the Kapowarr web interface.";
        default = false;
        type = types.bool;
      };

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.kapowarr = {
      description = "Kapowarr, a software to build and manage a comic book library";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = mkIf (cfg.databaseDir == "/var/lib/kapowarr") ''
        # make the default folders
        mkdir -p ${cfg.databaseDir}
        mkdir -p ${cfg.tempdownloadDir}
        mkdir -p ${cfg.logDir}
        # set the owner:group for them
        chown -R ${cfg.user}:${cfg.group} ${cfg.databaseDir}
        chown -R ${cfg.user}:${cfg.group} ${cfg.tempdownloadDir}
        chown -R ${cfg.user}:${cfg.group} ${cfg.logDir}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = mkIf (cfg.databaseDir == "/var/lib/kapowarr") "kapowarr";
        WorkingDirectory = cfg.databaseDir;
        ReadWritePaths = cfg.databaseDir;
        ExecStart = "${cfg.package}/bin/kapowarr -o ${cfg.host} -p ${cfg.port} -d ${cfg.databaseDir} -l ${cfg.logDir} -f ${cfg.logName} -t ${cfg.tempdownloadDir}";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "kapowarr") {
      kapowarr = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.databaseDir;
      };
    };

    users.groups = mkIf (cfg.group == "kapowarr") {
      kapowarr = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with maintainers; [ JollyDevelopment ];
}
