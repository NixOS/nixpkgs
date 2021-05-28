{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.teeworlds;
  register = cfg.register;

  teeworldsConf = pkgs.writeText "teeworlds.cfg" ''
    sv_port ${toString cfg.port}
    sv_register ${if cfg.register then "1" else "0"}
    ${optionalString (cfg.name != null) "sv_name ${cfg.name}"}
    ${optionalString (cfg.motd != null) "sv_motd ${cfg.motd}"}
    ${optionalString (cfg.password != null) "password ${cfg.password}"}
    ${optionalString (cfg.rconPassword != null) "sv_rcon_password ${cfg.rconPassword}"}
    ${concatStringsSep "\n" cfg.extraOptions}
  '';

in
{
  options = {
    services.teeworlds = {
      enable = mkEnableOption "Teeworlds Server";

      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open firewall ports for Teeworlds";
      };

      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Name of the server. Defaults to 'unnamed server'.
        '';
      };

      register = mkOption {
        type = types.bool;
        example = true;
        default = false;
        description = ''
          Whether the server registers as public server in the global server list. This is disabled by default because of privacy.
        '';
      };

      motd = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Set the server message of the day text.
        '';
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password to connect to the server.
        '';
      };

      rconPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password to access the remote console. If not set, a randomly generated one is displayed in the server log.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 8303;
        description = ''
          Port the server will listen on.
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra configuration lines for the <filename>teeworlds.cfg</filename>. See <link xlink:href="https://www.teeworlds.com/?page=docs&amp;wiki=server_settings">Teeworlds Documentation</link>.
        '';
        example = [ "sv_map dm1" "sv_gametype dm" ];
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openPorts {
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.teeworlds = {
      description = "Teeworlds Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.teeworlds}/bin/teeworlds_srv -f ${teeworldsConf}";

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
