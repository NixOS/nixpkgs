{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.asphyxia-core;
  configAsIni = generators.toINIWithGlobalSection {} {
    globalSection = {
      port = cfg.port;
      bind = cfg.bind;
      ping_ip = cfg.pingIp;
      matching_port = cfg.matchingPort;
      allow_register = cfg.allowRegister;
      maintenance_mode = cfg.maintenanceMode;
      enable_paseli = cfg.enablePaseli;
    };
    sections = {};
  };

  configIniFile = pkgs.writeText "config.ini" configAsIni;

  configDir = pkgs.runCommand "createConfigDir" {} ''
    mkdir -p $out
    ln -s ${configIniFile} $out/config.ini
    ln -s ${corePlugins} $out/plugins
  '';

  corePlugins = pkgs.fetchgit {
    url = "https://github.com/asphyxia-core/plugins";
    rev = "81630a86a299fd278b86b04dd94ece0b36525b2f";
    sha256 = "sha256-HNtVzlnGbOqXWVbyRqV4sJWOGk9srARPx7vAjmAh4QY=";
  };
in
{
  options = {
    services.asphyxia-core = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If enabled, starts an Asphyxia-core server.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8083;
        description = lib.mdDoc ''
          Specifies the port to listen on.
        '';
      };

      matchingPort = mkOption {
        type = types.port;
        default = 5700;
        description = lib.mdDoc ''
          Specifies the matching port to listen on for multiplayer sessions.
        '';
      };

      bind = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc ''
          Sets the hostname or IP address to bind to.
        '';
      };

      pingIp = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc ''
          An ICMP pingable target to make your games think they are online.
        '';
      };

      allowRegister = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to allow user registration.
        '';
      };

      enablePaseli = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable Paseli.
        '';
      };

      maintenanceMode = mkEnableOption "the maintenance mode";

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to automatically open ports in the firewall.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.asphyxia-core;
        description = lib.mdDoc ''
          Asphyxia package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.asphyxia = {
      description = "Asphyxia Server Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        StateDirectory="asphyxia-core";
        WorkingDirectory="${dirOf configIniFile}";
        ExecStart="exec -a ${configDir}/asphyxia-core ${cfg.package}/bin/asphyxia-core -d /var/lib/asphyxia-core";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictRealtime = true;
        RestrictNamespaces = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port cfg.matchingPort ];
    };
  };
}
