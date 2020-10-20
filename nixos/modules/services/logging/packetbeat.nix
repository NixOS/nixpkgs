{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.packetbeat;

  lt6 = builtins.compareVersions cfg.package.version "6" < 0;

  packetbeatYml = pkgs.writeText "packetbeat.yml" ''
    name: ${cfg.name}
    tags: ${builtins.toJSON cfg.tags}

    ${optionalString lt6 "packetbeat.cursor_state_file: /var/lib/${cfg.stateDir}/cursor-state"}

    ${cfg.extraConfig}
  '';

in
{
  options = {

    services.packetbeat = {

      enable = mkEnableOption "packetbeat";

      package = mkOption {
        type = types.package;
        default = pkgs.packetbeat;
        defaultText = "pkgs.packetbeat";
        example = literalExample "pkgs.packetbeat7";
        description = ''
          The packetbeat package to use
        '';
      };

      name = mkOption {
        type = types.str;
        default = "packetbeat";
        description = "Name of the beat";
      };

      tags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Tags to place on the shipped log messages";
      };

      stateDir = mkOption {
        type = types.str;
        default = "packetbeat";
        description = ''
          Directory below <literal>/var/lib/</literal> to store packetbeat's
          own logs and other data. This directory will be created automatically
          using systemd's StateDirectory mechanism.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = optionalString lt6 ''
          packetbeat:
            seek_position: cursor
            cursor_seek_fallback: tail
            write_cursor_state: true
            cursor_flush_period: 5s
            clean_field_names: true
            convert_to_numbers: false
            move_metadata_to_field: packet
            default_type: packet
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
          "The option services.packetbeat.stateDir shouldn't be an absolute directory." +
          " It should be a directory relative to /var/lib/.";
      }
    ];

    systemd.services.packetbeat = {
      description = "Packetbeat log shipper";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.stateDir}/data
        mkdir -p ${cfg.stateDir}/logs
      '';
      serviceConfig = {
        StateDirectory = cfg.stateDir;
        ExecStart = ''
          ${cfg.package}/bin/packetbeat run \
            -c ${packetbeatYml} \
            -path.data /var/lib/${cfg.stateDir}/data \
            -path.logs /var/lib/${cfg.stateDir}/logs'';
        Restart = "always";
        # ElasticSearch takes a while to start, so if the beat runs on the
        # same machine as ElasticSearch, the beat service becomes fragile and tends to time out.
        # We cannot define the beat to have a dependency on the elasticsearch.service
        # because it is not required to be on the same machine.
        RestartSec = 3;
      };
    };
  };
}
