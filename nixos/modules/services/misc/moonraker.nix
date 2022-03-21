{ config, lib, options, pkgs, ... }:
with lib;
let
  pkg = pkgs.moonraker;
  cfg = config.services.moonraker;
  opt = options.services.moonraker;
  format = pkgs.formats.ini {
    # https://github.com/NixOS/nixpkgs/pull/121613#issuecomment-885241996
    listToValue = l:
      if builtins.length l == 1 then generators.mkValueStringDefault {} (head l)
      else lib.concatMapStrings (s: "\n  ${generators.mkValueStringDefault {} s}") l;
    mkKeyValue = generators.mkKeyValueDefault {} ":";
  };
in {
  options = {
    services.moonraker = {
      enable = mkEnableOption "Moonraker, an API web server for Klipper";

      klipperSocket = mkOption {
        type = types.path;
        default = config.services.klipper.apiSocket;
        defaultText = literalExpression "config.services.klipper.apiSocket";
        description = "Path to Klipper's API socket.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/moonraker";
        description = "The directory containing the Moonraker databases.";
      };

      configDir = mkOption {
        type = types.path;
        default = cfg.stateDir + "/config";
        defaultText = literalExpression ''config.${opt.stateDir} + "/config"'';
        description = ''
          The directory containing client-writable configuration files.

          Clients will be able to edit files in this directory via the API. This directory must be writable.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "moonraker";
        description = "User account under which Moonraker runs.";
      };

      group = mkOption {
        type = types.str;
        default = "moonraker";
        description = "Group account under which Moonraker runs.";
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "The IP or host to listen on.";
      };

      port = mkOption {
        type = types.ints.unsigned;
        default = 7125;
        description = "The port to listen on.";
      };

      settings = mkOption {
        type = format.type;
        default = { };
        example = {
          authorization = {
            trusted_clients = [ "10.0.0.0/24" ];
            cors_domains = [ "https://app.fluidd.xyz" ];
          };
        };
        description = ''
          Configuration for Moonraker. See the <link xlink:href="https://moonraker.readthedocs.io/en/latest/configuration/">documentation</link>
          for supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = optional (cfg.settings ? update_manager)
      ''Enabling update_manager is not supported on NixOS and will lead to non-removable warnings in some clients.'';

    users.users = optionalAttrs (cfg.user == "moonraker") {
      moonraker = {
        group = cfg.group;
        uid = config.ids.uids.moonraker;
      };
    };

    users.groups = optionalAttrs (cfg.group == "moonraker") {
      moonraker.gid = config.ids.gids.moonraker;
    };

    environment.etc."moonraker.cfg".source = let
      forcedConfig = {
        server = {
          host = cfg.address;
          port = cfg.port;
          klippy_uds_address = cfg.klipperSocket;
          config_path = cfg.configDir;
          database_path = "${cfg.stateDir}/database";
        };
      };
      fullConfig = recursiveUpdate cfg.settings forcedConfig;
    in format.generate "moonraker.cfg" fullConfig;

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -"
      "d '${cfg.configDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.moonraker = {
      description = "Moonraker, an API web server for Klipper";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]
        ++ optional config.services.klipper.enable "klipper.service";

      # Moonraker really wants its own config to be writable...
      script = ''
        cp /etc/moonraker.cfg ${cfg.configDir}/moonraker-temp.cfg
        chmod u+w ${cfg.configDir}/moonraker-temp.cfg
        exec ${pkg}/bin/moonraker -c ${cfg.configDir}/moonraker-temp.cfg
      '';

      serviceConfig = {
        WorkingDirectory = cfg.stateDir;
        Group = cfg.group;
        User = cfg.user;
      };
    };
  };
}
