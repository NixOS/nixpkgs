{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.journalbeat;

  lt6 = builtins.compareVersions cfg.package.version "6" < 0;

  journalbeatYml = pkgs.writeText "journalbeat.yml" ''
    name: ${cfg.name}
    tags: ${builtins.toJSON cfg.tags}

    ${optionalString lt6 "journalbeat.cursor_state_file: /var/lib/${cfg.stateDir}/cursor-state"}

    ${cfg.extraConfig}
  '';

in
{
  options = {

    services.journalbeat = {

      enable = mkEnableOption "journalbeat";

      package = mkOption {
        type = types.package;
        default = pkgs.journalbeat;
        defaultText = "pkgs.journalbeat";
        example = literalExample "pkgs.journalbeat7";
        description = ''
          The journalbeat package to use
        '';
      };

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
          Directory below <literal>/var/lib/</literal> to store journalbeat's
          own logs and other data. This directory will be created automatically
          using systemd's StateDirectory mechanism.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = optionalString lt6 ''
          journalbeat:
            seek_position: cursor
            cursor_seek_fallback: tail
            write_cursor_state: true
            cursor_flush_period: 5s
            clean_field_names: true
            convert_to_numbers: false
            move_metadata_to_field: journal
            default_type: journal
        '';
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
