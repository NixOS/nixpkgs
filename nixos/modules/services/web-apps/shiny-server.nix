{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.shiny-server;

  generatedConfig = pkgs.writeText "shiny-server.conf" ''
    run_as ${cfg.user};
    server {
      listen ${toString cfg.port};
      location / {
        site_dir ${cfg.siteDir};
        log_dir ${cfg.logDir};
        bookmark_state_dir ${cfg.stateDir};
        directory_index ${boolToString cfg.directoryIndex};
        ${cfg.extraRootLocationConfig}
      }
    }
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.shiny-server = {
      enable = mkEnableOption "Enable server to host R Shiny applications.";

      package = mkOption {
        default = pkgs.shiny-server.override {
          extraRPackages = cfg.extraPackages;
        };
        defaultText = ''pkgs.shiny-server.override {
          extraRPackages = cfg.extraPackages;
        };
        '';
        description = "Shiny Server package";
      };

      extraPackages = mkOption {
        default = [];
        example = literalExample "with pkgs.rPackages; [ ggplot2 data_table ];";
        description = ''
          Extra packages to include in the rWrapper used by shiny-server.
          Use this to enable additional R packages.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 3838;
        description = ''
          Port number Shiny Server will be listening to.
        '';
      };

      directoryIndex = mkOption {
        type = types.bool;
        default = true;
        description = "Whether directory content is displayed";
      };

      user = mkOption {
        default = "shiny";
        description = "User to run Shiny Server as";
      };

      siteDir = mkOption {
        type = types.path;
        default = "${cfg.package}/shiny-server/samples";
        defaultText = "\${cfg.package}/shiny-server/samples";
        description = "Directory containing shiny apps to serve";
      };
      logDir = mkOption {
        type = types.path;
        default = "/var/lib/shiny/log";
        description = "Directory to write server logs";
      };
      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/shiny/state";
        description = "Directory to store server state (bookmarks)";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines to be added to the generated configuration file.
        '';
      };
      extraRootLocationConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines to be added inside 'location /' in the generated
          configuration file.
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = generatedConfig;
        defaultText = "generatedConfig";
        description = ''
          Overridable configuration file. Defaults is the one generated.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.shiny = optionalAttrs (cfg.user == "shiny") {
      name = cfg.user;
      uid = config.ids.uids.shiny;
      group = cfg.user;
      description = "Shiny Server user";
    };
    users.groups.shiny = optionalAttrs (cfg.user == "shiny") {
      name = cfg.user;
      gid = config.ids.gids.shiny;
    };

    systemd.services.shiny-server = {
      description = "Shiny Application Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p ${cfg.stateDir} ${cfg.logDir}
        chown ${cfg.user} ${cfg.stateDir} ${cfg.logDir}
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/shiny-server ${cfg.configFile}";
        User = cfg.user;
        PermissionsStartOnly = true;
      };
    };
  };
}
