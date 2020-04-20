{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.mindustry;
  name = "Mindustry";

  serverConfig = {
    name = cfg.game-name;
    port = (toString cfg.port);
  } // cfg.extraConfig;
  serverConfigCommands = (attrsets.mapAttrsToList (k: v:
    "config ${k} ${if builtins.isBool v then boolToString v else toString v}")
    serverConfig);
  serverCommands = cfg.extraCommands ++ serverConfigCommands
    ++ [ "host ${cfg.game-map} ${cfg.game-mode}" ];
in {
  options = {
    services.mindustry = {
      enable = mkEnableOption name;
      package = mkOption {
        type = types.package;
        default = pkgs.mindustry-server;
        defaultText = "pkgs.mindustry-server";
        description = ''
          Mindustry server package to use.
        '';
      };
      port = mkOption {
        type = types.int;
        default = 6567;
        description = ''
          The port to host on.
        '';
      };
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };
      game-mode = mkOption {
        type = types.nullOr types.str;
        default = "";
        description = ''
          The gamemode that mindustry-server should host. Leaving both game-mode and game-map empty results in a random survival map.
        '';
      };
      game-map = mkOption {
        type = types.nullOr types.str;
        default = "";
        description = ''
          The map that mindustry-server should host. Leaving both game-mode and game-map empty results in a random survival map.
        '';
      };
      game-name = mkOption {
        type = types.str;
        default = "Mindustry";
        description = ''
          The server name as displayed on clients.
        '';
      };
      extraCommands = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "playerlimit 8" "reloadmaps" ];
        description = ''
          Extra commands passed to mindustry-server.

          A list of all commands for the current version of mindustry-server can be found via
          <programlisting language="bash"><![CDATA[mindustry-server help]]></programlisting>
        '';
      };
      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        example = {
          enableVotekick = true;
          socketInput = true;
        };
        description = ''
         Extra game configuration passed to mindustry-server via the config argument.

         A list of all game configuration for the current version of mindustry-server can be found via
         <programlisting language="bash"><![CDATA[mindustry-server config]]></programlisting>
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mindustry = {
      description = "Mindustry headless server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        StateDirectory = "mindustry";
        WorkingDirectory = "/var/lib/mindustry";
        ExecStart = toString [
          "${cfg.package}/bin/mindustry-server"
          (builtins.concatStringsSep "," serverCommands)
        ];
      };
    };
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ oro ];
}
