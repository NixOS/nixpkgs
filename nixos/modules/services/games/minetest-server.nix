{
  config,
  lib,
  pkgs,
  ...
}:
let
  CONTAINS_NEWLINE_RE = ".*\n.*";
  # The following values are reserved as complete option values:
  # { - start of a group.
  # """ - start of a multi-line string.
  RESERVED_VALUE_RE = "[[:space:]]*(\"\"\"|\\{)[[:space:]]*";
  NEEDS_MULTILINE_RE = "${CONTAINS_NEWLINE_RE}|${RESERVED_VALUE_RE}";

  # There is no way to encode """ on its own line in a Minetest config.
  UNESCAPABLE_RE = ".*\n\"\"\"\n.*";

  toConfMultiline =
    name: value:
    assert lib.assertMsg (
      (builtins.match UNESCAPABLE_RE value) == null
    ) ''""" can't be on its own line in a minetest config.'';
    "${name} = \"\"\"\n${value}\n\"\"\"\n";

  toConf = values:
    lib.concatStrings (
      lib.mapAttrsToList (
        name: value:
        {
          bool = "${name} = ${toString value}\n";
          int = "${name} = ${toString value}\n";
          null = "";
          set = "${name} = {\n${toConf value}}\n";
          string =
            if (builtins.match NEEDS_MULTILINE_RE value) != null then
              toConfMultiline name value
            else
              "${name} = ${value}\n";
        }.${builtins.typeOf value}
      ) values
    );

  flag = val: name: lib.optionals (val != null) ["--${name}" (toString val)];
in {
  options.services.minetest-server = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable this Minetest server instance.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.minetest;
          defaultText = lib.literalExpression "pkgs.minetest";
          description = "Minetest server package to use";
        };

        gameId = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Game ID to use (run 'minetestserver --gameid list' for options). If not set and there is only one game in the server folder, will use that.";
        };

        world = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "World directory name to use";
        };

        configPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to custom config file";
        };

        config = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = {};
          description = "Configuration settings (ignored if configPath is set). All options here: https://github.com/minetest/minetest/blob/master/minetest.conf.example";
        };

        logPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to log file (null for stdout)";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 30000;
          description = "Port to listen on (default: 30000)";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to open the UDP port in the firewall for this instance.";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Additional command-line arguments";
        };

        fetchGame = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = pkgs.fetchFromGitHub {
            owner = "luanti-org";
            repo  = "minetest_game";
            rev   = "838ad60";  # latest commit on Apr 19, 2025
            sha256 = "sha256-UVKsbfOQG5WD2/w6Yxdn6bMfgcexs09OBY+wdWtNuE0=";
          };
          description = "Derivation containing game files";
          #example = 
        };
      };
    });
    default = {};
    description = "Multiple Minetest server instances";
  };

  config = let
    cfg = config.services.minetest-server;
    enabledInstances = lib.filterAttrs (_: ic: ic.enable) cfg;
  in lib.mkIf (enabledInstances != {}) {
    networking.firewall.allowedUDPPorts = lib.concatMap (ic: # open firewall
      lib.optional ic.openFirewall ic.port
    ) (lib.attrValues enabledInstances);

  systemd.services = lib.mapAttrs' (name: instanceCfg: {
      name = "minetest-server-${name}";
      value = {
        description = "minetest Server Instance: ${name}";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "minetest-${name}"; # will be /var/lib/minetest-${name}
          Restart = "always";
          WorkingDirectory = "/var/lib/minetest-${name}";
        };
        environment = {
          HOME = "/var/lib/minetest-${name}";
        };

        preStart = let
          fetchGame = instanceCfg.fetchGame;
        in ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail
          target_dir="/var/lib/minetest-${name}/.minetest/games/${instanceCfg.gameId}"
          mkdir -p "$target_dir"

          # Directory source (fetchFromGitHub/fetchgit)
          ${pkgs.rsync}/bin/rsync -a --delete \
            "${fetchGame}/" \
            "$target_dir/"
        '';

        script = let
          flags = [
              "--server"
            ]
            ++ (if instanceCfg.configPath != null then [
              "--config" instanceCfg.configPath
            ] else [
              "--config" (builtins.toFile "minetest-${name}.conf" (toConf instanceCfg.config))
            ])
            ++ (flag instanceCfg.gameId "gameid")
            ++ (if instanceCfg.world != null then
                  [ "--world"   "worlds/${instanceCfg.world}" ]
                else
                  []
              )
            ++ (flag instanceCfg.logPath "logfile")
            ++ (flag instanceCfg.port "port")
            ++ instanceCfg.extraArgs;
        in ''
          cd "$STATE_DIRECTORY"
          exec ${instanceCfg.package}/bin/minetest ${lib.escapeShellArgs flags}
        '';
      };
    }) enabledInstances;
  };
}