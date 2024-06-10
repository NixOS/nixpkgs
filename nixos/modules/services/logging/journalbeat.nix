{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.journalbeat;

  journalbeatYml = pkgs.writeText "journalbeat.yml" ''
    name: ${cfg.name}
    tags: ${builtins.toJSON cfg.tags}

    ${cfg.extraConfig}
  '';

in
{
  options = {

    services.journalbeat = {

      enable = mkEnableOption "journalbeat";

      package = mkPackageOption pkgs "journalbeat" { };

      name = mkOption {
        type = types.str;
        default = "journalbeat";
        description = "Name of the beat";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Tags to place on the shipped log messages";
      };

      stateDir = mkOption {
        type = types.str;
        default = "journalbeat";
        description = ''
          Directory below `/var/lib/` to store journalbeat's
          own logs and other data. This directory will be created automatically
          using systemd's StateDirectory mechanism.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Any other configuration options you want to add";
      };

    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = !hasPrefix "/" cfg.stateDir;
        message =
          "The option services.journalbeat.stateDir shouldn't be an absolute directory." +
          " It should be a directory relative to /var/lib/.";
      }
    ];

    systemd.services.journalbeat = {
      description = "Journalbeat log shipper";
      wantedBy = [ "multi-user.target" ];
      wants = [ "elasticsearch.service" ];
      after = [ "elasticsearch.service" ];
      preStart = ''
        mkdir -p ${cfg.stateDir}/data
        mkdir -p ${cfg.stateDir}/logs
      '';
      serviceConfig = {
        StateDirectory = cfg.stateDir;
        ExecStart = ''
          ${cfg.package}/bin/journalbeat \
            -c ${journalbeatYml} \
            -path.data /var/lib/${cfg.stateDir}/data \
            -path.logs /var/lib/${cfg.stateDir}/logs'';
        Restart = "always";
      };
    };
  };
}
