{ config, lib, pkgs, ... }:

let
  cfg = config.services.zeronsd;
  settingsFormat = pkgs.formats.json {};
  inherit (lib) mkOption;
in {
  options.services.zeronsd.enable = lib.mkEnableOption (lib.mdDoc "ZeroNSD");

  options.services.zeronsd.servedNetworks = mkOption {
    default = [];
    example = [ "a8a2c3c10c1a68de" ];
    type = lib.types.listOf lib.types.str;
    description = lib.mdDoc "List of ZeroTier Network IDs to start zeronsd instance for.";
  };

  options.services.zeronsd.settings = lib.mkOption {
    description = ''
      Settings for zeronsd
    '';
    type = lib.types.submodule {
      freeformType = settingsFormat.type;

      options.domain = lib.mkOption {
        default = "home.arpa";
        type = lib.types.str;
        description = lib.mdDoc ''
          Domain under which ZeroTier records will be available
        '';
      };

      options.token = lib.mkOption {
        default = null;
        type = lib.types.path;
        description = lib.mdDoc ''
          Path to a file containing the API Token for ZeroTier Central
        '';
      };

      options.log-level = lib.mkOption {
        default = "info";
        type = lib.types.str;
        description = lib.mdDoc ''
          Log Level (one of off, error, warn, info, debug, trace)
        '';
      };

      options.wildcard = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Whether to server a wildcard record for ZeroTier Nodes
        '';
      };
    };
  };

  options.services.zeronsd.package = lib.mkOption {
    default = pkgs.zeronsd;
    defaultText = lib.literalExpression "pkgs.zeronsd";
    type = lib.types.package;
    description = lib.mdDoc ''
      Zeronsd package to use.
    '';
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.zerotierone.enable;
        message = "zeronsd needs a configured zerotier-one";
      }
      {
        assertion = cfg.servedNetworks != [];
        message = "At least one ZeroTier network needs to be configured in services.zeronsd.servedNetworks";
      }
    ];
    systemd.services = builtins.listToAttrs (builtins.map (net: {
      name = "zeronsd-${net}";
      value = {
        description = "ZeroTier DNS server for Network ${net}";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "zerotierone.service" ];
        requires = [ "network-online.target" ];

        path = [ cfg.package ];

        serviceConfig = let
          configFile = pkgs.writeText "zeronsd.json" (builtins.toJSON cfg.settings);
          # This is required as zeronsd needs to read the token file from the zerotier-one daemon
          execPreScript = pkgs.writeShellScript "zeronsd-pre" ''
            ${pkgs.acl}/bin/setfacl -m u:zeronsd:x /var/lib/zerotier-one
            ${pkgs.acl}/bin/setfacl -m u:zeronsd:r /var/lib/zerotier-one/authtoken.secret
          '';
        in {
          ExecStart = "${cfg.package}/bin/zeronsd start --config ${configFile} --config-type json ${net}";
          ExecStartPre = "!${execPreScript}";
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 5;
          User = "zeronsd";
          Group = "zeronsd";
          AmbientCapabilities = "cap_net_bind_service";
        };
      };
    }) cfg.servedNetworks);

    environment.systemPackages = [ cfg.package ];

    users.users.zeronsd = {
      group = "zeronsd";
      description = "Service User for running Zeronsd";
      isSystemUser = true;
    };

    users.groups.zeronsd = {};
  };
}
