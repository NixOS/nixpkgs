{ pkgs, config, lib, ... }:

let
  cfg = config.services.mympd;
in {
  options = {

    services.mympd = {

      enable = lib.mkEnableOption (lib.mdDoc "MyMPD server");

      package = lib.mkPackageOption pkgs "mympd" {};

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports needed for the functionality of the program.
        '';
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "music" ];
        description = lib.mdDoc ''
          Additional groups for the systemd service.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf (nullOr (oneOf [ str bool int ]));
          options = {
            http_port = lib.mkOption {
              type = lib.types.port;
              description = lib.mdDoc ''
                The HTTP port where mympd's web interface will be available.

                The HTTPS/SSL port can be configured via {option}`config`.
              '';
              example = "8080";
            };

            ssl = lib.mkOption {
              type = lib.types.bool;
              description = lib.mdDoc ''
                Whether to enable listening on the SSL port.

                Refer to <https://jcorporation.github.io/myMPD/configuration/configuration-files#ssl-options>
                for more information.
              '';
              default = false;
            };
          };
        };
        description = lib.mdDoc ''
          Manages the configuration files declaratively. For all the configuration
          options, see <https://jcorporation.github.io/myMPD/configuration/configuration-files>.

          Each key represents the "File" column from the upstream configuration table, and the
          value is the content of that file.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.mympd = {
      # upstream service config: https://github.com/jcorporation/myMPD/blob/master/contrib/initscripts/mympd.service.in
      after = [ "mpd.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = with lib; ''
        config_dir="/var/lib/mympd/config"
        mkdir -p "$config_dir"

        ${pipe cfg.settings [
          (mapAttrsToList (name: value: ''
            echo -n "${if isBool value then boolToString value else toString value}" > "$config_dir/${name}"
            ''))
          (concatStringsSep "\n")
        ]}
      '';
      unitConfig = {
        Description = "myMPD server daemon";
        Documentation = "man:mympd(1)";
      };
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictRealtime = true;
        StateDirectory = "mympd";
        CacheDirectory = "mympd";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_UNIX";
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        SupplementaryGroups = cfg.extraGroups;
      };
    };

    networking.firewall = lib.mkMerge [
      (lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.settings.http_port ];
      })
      (lib.mkIf (cfg.openFirewall && cfg.settings.ssl && cfg.settings.ssl_port != null) {
        allowedTCPPorts = [ cfg.settings.ssl_port ];
      })
    ];

  };

  meta.maintainers = [ lib.maintainers.eliandoran ];

}
