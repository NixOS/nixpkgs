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

  # There is no way to encode """ on its own line in a Luanti config.
  UNESCAPABLE_RE = ".*\n\"\"\"\n.*";

  toConfMultiline =
    name: value:
    assert lib.assertMsg (
      (builtins.match UNESCAPABLE_RE value) == null
    ) ''""" can't be on its own line in a luanti config.'';
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

  oldCfg = config.services.minetest-server;
in {
  imports = [
    (lib.mkRemovedOptionModule ["services" "minetest-server"] ''
      The Minetest server module has been replaced by the Luanti multi-instance configuration.
      
      Instead of:
        services.minetest-server = { ... };
      
      Use:
        services.luanti-servers.<instanceName> = { ... };
      
      See https://<your-docs-url> for migration guide.
    '')
  ];

  # Add assertions for specific old options
  assertions = [
    {
      assertion = oldCfg.enable;
      message = ''
        The minetest-server service has been replaced by luanti-servers!
        
        Update your configuration from:
          services.minetest-server = { ... };
        to:
          services.luanti-servers.<instanceName> = { 
            enable = true;
            # Old options map to:
            port = <old-port>;
            gameId = <old-gameId>;
            # ... etc ...
          };
      '';
    }
  ];

  options.services.luanti-servers = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable this Luanti server instance.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.luanti;
          defaultText = lib.literalExpression "pkgs.luanti";
          description = "Luanti server package to use";
        };

        gameId = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Game ID to use (run 'luantiserver --gameid list' for options). If not set and there is only one game in the server folder, will use that.";
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
          description = "Configuration settings (ignored if configPath is set). All options here: https://github.com/luanti-org/luanti/blob/master/minetest.conf.example";
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
          example = ''
          pkgs.fetchgit {
            url = "https://codeberg.org/mineclonia/mineclonia.git";
            rev = "0.114.0";
            sha256 = "sha256-3dnbQZQkHjYwfb6ACAckkJ6Sss25wNvPrt6toqiesDo=";
          };
          '';
        };
      };
    });
    default = {};
    description = "Multiple Luanti server instances";
    example = '' 
    {
      testServer = {
        enable = true;
        port = 30000;
        openFirewall = true;
        config = {
          # all default options: https://github.com/minetest/minetest/blob/master/minetest.conf.example
          serverName = "VoxeLiber server";
          serverDescription = "👍";
          defaultGame = "mineclone2";
          serverAnnounce = false;
          enableDamage = true;
          creativeMode = false;
        };
        world = "world";
        fetchGame = pkgs.fetchgit {
          url       = "https://git.minetest.land/VoxeLibre/VoxeLibre.git";
          rev       = "refs/tags/0.89.2"; # or simply "0.89.2"
          sha256 = "sha256-57nrDr8W7SadNH15FRaFp1+cCUelyhwEdij79H8Fwhs=";
        };
        gameId = "mineclone2";
      };
    };
    '';
  };

  config = let
    cfg = config.services.luanti-servers;
    enabledInstances = lib.filterAttrs (_: ic: ic.enable) cfg;
  in lib.mkIf (enabledInstances != {}) {
    networking.firewall.allowedUDPPorts = lib.concatMap (ic: # open firewall
      lib.optional ic.openFirewall ic.port
    ) (lib.attrValues enabledInstances);

  systemd.services = lib.mapAttrs' (name: instanceCfg: {
      name = "luanti-server-${name}";
      value = {
        description = "luanti Server Instance: ${name}";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "luanti-${name}"; # will be /var/lib/luanti-${name}
          Restart = "always";
          WorkingDirectory = "/var/lib/luanti-${name}";
        };
        environment = {
          HOME = "/var/lib/luanti-${name}";
        };

        preStart = let
          fetchGame = instanceCfg.fetchGame;
        in ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail
          target_dir="/var/lib/luanti-${name}/.luanti/games/${instanceCfg.gameId}"
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
              "--config" (builtins.toFile "luanti-${name}.conf" (toConf instanceCfg.config))
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
          exec ${instanceCfg.package}/bin/luanti ${lib.escapeShellArgs flags}
        '';
      };
    }) enabledInstances;
  };
}