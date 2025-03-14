{
  config,
  lib,
  pkgs,
  ...
}:
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

      enable = lib.mkEnableOption "journalbeat";

      package = lib.mkPackageOption pkgs "journalbeat" { };

      name = lib.mkOption {
        type = lib.types.str;
        default = "journalbeat";
        description = "Name of the beat";
      };

      tags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Tags to place on the shipped log messages";
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "journalbeat";
        description = ''
          Directory below `/var/lib/` to store journalbeat's
          own logs and other data. This directory will be created automatically
          using systemd's StateDirectory mechanism.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Any other configuration options you want to add";
      };

    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !lib.hasPrefix "/" cfg.stateDir;
        message =
          "The option services.journalbeat.stateDir shouldn't be an absolute directory."
          + " It should be a directory relative to /var/lib/.";
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
