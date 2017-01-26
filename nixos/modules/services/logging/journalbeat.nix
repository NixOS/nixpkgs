{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.journalbeat;

  journalbeatYml = pkgs.writeText "journalbeat.yml" ''
    name: ${cfg.name}
    tags: ${builtins.toJSON cfg.tags}

    journalbeat.cursor_state_file: ${cfg.stateDir}/cursor-state

    ${cfg.extraConfig}
  '';

in
{
  options = {

    services.journalbeat = {

      enable = mkEnableOption "journalbeat";

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
        default = "/var/lib/journalbeat";
        description = "The state directory. Journalbeat's own logs and other data are stored here.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = ''
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

    systemd.services.journalbeat = with pkgs; {
      description = "Journalbeat log shipper";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.stateDir}/data
        mkdir -p ${cfg.stateDir}/logs
      '';
      serviceConfig = {
        ExecStart = "${pkgs.journalbeat}/bin/journalbeat -c ${journalbeatYml} -path.data ${cfg.stateDir}/data -path.logs ${cfg.stateDir}/logs";
      };
    };
  };
}
