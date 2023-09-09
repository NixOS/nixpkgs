{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.teeworlds;
  configFile = pkgs.writeText "teeworlds.conf" (concatStringsSep "\n" (mapAttrsToList (key: value: "${key} ${toString value}") cfg.settings));
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "teeworlds" "name" ]
      [ "services" "teeworlds" "settings" "sv_name" ])
    (mkRenamedOptionModule
      [ "services" "teeworlds" "register" ]
      [ "services" "teeworlds" "settings" "sv_register" ])
    (mkRenamedOptionModule
      [ "services" "teeworlds" "motd" ]
      [ "services" "teeworlds" "settings" "sv_motd" ])
    (mkRenamedOptionModule
      [ "services" "teeworlds" "password" ]
      [ "services" "teeworlds" "settings" "password" ])
    (mkRenamedOptionModule
      [ "services" "teeworlds" "rcon_password" ]
      [ "services" "teeworlds" "settings" "sv_rcon_password" ])
    (mkRenamedOptionModule
      [ "services" "teeworlds" "port" ]
      [ "services" "teeworlds" "settings" "sv_port" ])
    (mkRemovedOptionModule [ "services" "teeworlds" "extraOptions" ]
      "Use services.teeworlds.settings instead.")
  ];

  options.services.teeworlds = {
    enable = mkEnableOption (lib.mdDoc "Teeworlds Server");

    openPorts = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open firewall ports for Teeworlds
      '';
    };

    settings = mkOption {
      default = {};
      example = ''
        {
          sv_motd = "Welcome to this teeworlds ctf server!";
          sv_map = "ctf1";
          sv_gametype = "ctf";
        }
      '';
      description = lib.mdDoc ''
        See [Teeworlds Documentation](https://www.teeworlds.com/?page=docs&wiki=server_settings) for all configuration options.
      '';
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf (nullOr (oneOf [ str int bool ]));

        options = {
          sv_name = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Name of the server. Defaults to 'unnamed server'.
            '';
          };

          sv_register = mkOption {
            type = types.int;
            example = 1;
            default = 0;
            description = lib.mdDoc ''
              Whether the server registers as public server in the global server list. This is disabled (0) by default because of privacy.
            '';
          };

          sv_motd = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Set the server message of the day text.
            '';
          };

          password = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Password to connect to the server.
            '';
          };

          sv_rcon_password = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Password to access the remote console. If not set, a randomly generated one is displayed in the server log.
            '';
          };

          sv_port = mkOption {
            type = types.port;
            default = 8303;
            description = lib.mdDoc ''
              Port the server will listen on.
            '';
          };
        };
      };
      apply = value:
        if isBool value
        then (if value then 1 else 0)
        else value;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openPorts {
      allowedUDPPorts = [ cfg.settings.sv_port ];
    };

    systemd.services.teeworlds = {
      description = "Teeworlds Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.teeworlds}/bin/teeworlds_srv -f ${configFile}";

        # Hardening
        CapabilityBoundingSet = false;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}
