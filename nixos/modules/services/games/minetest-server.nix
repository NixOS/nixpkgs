{ config, lib, pkgs, ... }:

with lib;

let
  CONTAINS_NEWLINE_RE = ".*\n.*";
  # The following values are reserved as complete option values:
  # { - start of a group.
  # """ - start of a multi-line string.
  RESERVED_VALUE_RE = "[[:space:]]*(\"\"\"|\\{)[[:space:]]*";
  NEEDS_MULTILINE_RE = "${CONTAINS_NEWLINE_RE}|${RESERVED_VALUE_RE}";

  # There is no way to encode """ on its own line in a Minetest config.
  UNESCAPABLE_RE = ".*\n\"\"\"\n.*";

  toConfMultiline = name: value:
    assert lib.assertMsg
      ((builtins.match UNESCAPABLE_RE value) == null)
      ''""" can't be on its own line in a minetest config.'';
    "${name} = \"\"\"\n${value}\n\"\"\"\n";

  toConf = values:
    lib.concatStrings
      (lib.mapAttrsToList
        (name: value: {
          bool = "${name} = ${toString value}\n";
          int = "${name} = ${toString value}\n";
          null = "";
          set = "${name} = {\n${toConf value}}\n";
          string =
            if (builtins.match NEEDS_MULTILINE_RE value) != null
            then toConfMultiline name value
            else "${name} = ${value}\n";
        }.${builtins.typeOf value})
        values);

  cfg   = config.services.minetest-server;
  flag  = val: name: lib.optionals (val != null) ["--${name}" "${toString val}"];

  flags = [
    "--server"
  ]
    ++ (
      if cfg.configPath != null
      then ["--config" cfg.configPath]
      else ["--config" (builtins.toFile "minetest.conf" (toConf cfg.config))])
    ++ (flag cfg.gameId "gameid")
    ++ (flag cfg.world "world")
    ++ (flag cfg.logPath "logfile")
    ++ (flag cfg.port "port")
    ++ cfg.extraArgs;
in
{
  options = {
    services.minetest-server = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "If enabled, starts a Minetest Server.";
      };

      gameId = mkOption {
        type        = types.nullOr types.str;
        default     = null;
        description = ''
          Id of the game to use. To list available games run
          `minetestserver --gameid list`.

          If only one game exists, this option can be null.
        '';
      };

      world = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = ''
          Name of the world to use. To list available worlds run
          `minetestserver --world list`.

          If only one world exists, this option can be null.
        '';
      };

      configPath = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = ''
          Path to the config to use.

          If set to null, the config of the running user will be used:
          `~/.minetest/minetest.conf`.
        '';
      };

      config = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        description = ''
          Settings to add to the minetest config file.

          This option is ignored if `configPath` is set.
        '';
      };

      logPath = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = ''
          Path to logfile for logging.

          If set to null, logging will be output to stdout which means
          all output will be caught by systemd.
        '';
      };

      port = mkOption {
        type        = types.nullOr types.int;
        default     = null;
        description = ''
          Port number to bind to.

          If set to null, the default 30000 will be used.
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Additional command line flags to pass to the minetest executable.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.minetest = {
      description     = "Minetest Server Service user";
      home            = "/var/lib/minetest";
      createHome      = true;
      uid             = config.ids.uids.minetest;
      group           = "minetest";
    };
    users.groups.minetest.gid = config.ids.gids.minetest;

    systemd.services.minetest-server = {
      description   = "Minetest Server Service";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig.Restart = "always";
      serviceConfig.User    = "minetest";
      serviceConfig.Group   = "minetest";

      script = ''
        cd /var/lib/minetest

        exec ${pkgs.minetest}/bin/minetest ${lib.escapeShellArgs flags}
      '';
    };
  };
}
