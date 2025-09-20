{
  config,
  lib,
  pkgs,
  ...
}:

with {
  inherit (lib)
    elemAt
    getExe
    hasAttrByPath
    mkEnableOption
    mkIf
    mkOption
    strings
    types
    ;
};

let
  mkDefaults = lib.mapAttrsRecursive (n: v: lib.mkDefault v);

  cfg = config.services.pihole-ftl;

  piholeScript = pkgs.writeScriptBin "pihole" ''
    sudo=exec
    if [[ "$USER" != '${cfg.user}' ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user}'
    fi
    $sudo ${getExe cfg.piholePackage} "$@"
  '';

  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "pihole.toml" cfg.settings;
in
{
  options.services.pihole-ftl = {
    enable = mkEnableOption "Pi-hole FTL";

    package = lib.mkPackageOption pkgs "pihole-ftl" { };
    piholePackage = lib.mkPackageOption pkgs "pihole" { };

    privacyLevel = mkOption {
      type = types.numbers.between 0 3;
      description = ''
        Level of detail in generated statistics. 0 enables full statistics, 3
        shows only anonymous statistics.

        See [the documentation](https://docs.pi-hole.net/ftldns/privacylevels).

        Also see services.dnsmasq.settings.log-queries to completely disable
        query logging.
      '';
      default = 0;
      example = 3;
    };

    openFirewallDNS = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports in the firewall for pihole-FTL's DNS server.";
    };

    openFirewallDHCP = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports in the firewall for pihole-FTL's DHCP server.";
    };

    openFirewallWebserver = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for pihole-FTL's webserver, as configured in `settings.webserver.port`.
      '';
    };

    configDirectory = mkOption {
      type = types.path;
      default = "/etc/pihole";
      internal = true;
      readOnly = true;
      description = ''
        Path for pihole configuration.
        pihole does not currently support any path other than /etc/pihole.
      '';
    };

    stateDirectory = mkOption {
      type = types.path;
      default = "/var/lib/pihole";
      description = ''
        Path for pihole state files.
      '';
    };

    logDirectory = mkOption {
      type = types.path;
      default = "/var/log/pihole";
      description = "Path for Pi-hole log files";
    };

    settings = mkOption {
      type = settingsFormat.type;
      description = ''
        Configuration options for pihole.toml.
        See the upstream [documentation](https://docs.pi-hole.net/ftldns/configfile).
      '';
    };

    useDnsmasqConfig = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Import options defined in [](#opt-services.dnsmasq.settings) via
        misc.dnsmasq_lines in Pi-hole's config.
      '';
    };

    macvendorURL = mkOption {
      type = types.str;
      default = "https://ftl.pi-hole.net/macvendor.db";
      description = ''
        URL from which to download the macvendor.db file.
      '';
    };

    pihole = mkOption {
      type = types.package;
      default = piholeScript;
      internal = true;
      description = "Pi-hole admin script";
    };

    lists =
      let
        adlistType = types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              description = "URL of the domain list";
            };
            type = mkOption {
              type = types.enum [
                "allow"
                "block"
              ];
              default = "block";
              description = "Whether domains on this list should be explicitly allowed, or blocked";
            };
            enabled = mkOption {
              type = types.bool;
              default = true;
              description = "Whether this list is enabled";
            };
            description = mkOption {
              type = types.str;
              description = "Description of the list";
              default = "";
            };
          };
        };
      in
      mkOption {
        type = with types; listOf adlistType;
        description = "Deny (or allow) domain lists to use";
        default = [ ];
        example = [
          {
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          }
        ];
      };

    user = mkOption {
      type = types.str;
      default = "pihole";
      description = "User to run the service as.";
    };

    group = mkOption {
      type = types.str;
      default = "pihole";
      description = "Group to run the service as.";
    };

    queryLogDeleter = {
      enable = mkEnableOption ("Pi-hole FTL DNS query log deleter");

      age = mkOption {
        type = types.int;
        default = 90;
        description = ''
          Delete DNS query logs older than this many days, if
          [](#opt-services.pihole-ftl.queryLogDeleter.enable) is on.
        '';
      };

      interval = mkOption {
        type = types.str;
        default = "weekly";
        description = ''
          How often the query log deleter is run. See systemd.time(7) for more
          information about the format.
        '';
      };
    };

    webserverEnabled = mkOption {
      type = types.bool;
      default = (
        (hasAttrByPath [ "webserver" "port" ] cfg.settings)
        && !builtins.elem cfg.settings.webserver.port [
          ""
          null
        ]
      );
      internal = true;
      description = "Whether the webserver is enabled.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.dnsmasq.enable;
        message = "pihole-ftl conflicts with dnsmasq. Please disable one of them.";
      }

      {
        assertion = builtins.length cfg.lists == 0 || cfg.webserverEnabled;
        message = ''
          The Pi-hole webserver must be enabled for lists set in services.pihole-ftl.lists to be automatically loaded on startup via the web API.
          services.pihole-ftl.settings.port must be defined, e.g. by enabling services.pihole-web.enable and defining services.pihole-web.port.
        '';
      }

      {
        assertion =
          builtins.length cfg.lists == 0
          || !(hasAttrByPath [ "webserver" "api" "cli_pw" ] cfg.settings)
          || cfg.settings.webserver.api.cli_pw == true;
        message = ''
          services.pihole-ftl.settings.webserver.api.cli_pw must be true for lists set in services.pihole-ftl.lists to be automatically loaded on startup.
          This enables an ephemeral password used by the pihole command.
        '';
      }
    ];

    services.pihole-ftl.settings = lib.mkMerge [
      # Defaults
      (mkDefaults {
        misc.readOnly = true; # Prevent config changes via API or CLI by default
        webserver.port = ""; # Disable the webserver by default
        misc.privacylevel = cfg.privacyLevel;
      })

      # Move state files to cfg.stateDirectory
      {
        # TODO: Pi-hole currently hardcodes dhcp-leasefile this in its
        # generated dnsmasq.conf, and we can't override it
        misc.dnsmasq_lines = [
          # "dhcp-leasefile=${cfg.stateDirectory}/dhcp.leases"
          # "hostsdir=${cfg.stateDirectory}/hosts"
        ];

        files = {
          database = "${cfg.stateDirectory}/pihole-FTL.db";
          gravity = "${cfg.stateDirectory}/gravity.db";
          macvendor = "${cfg.stateDirectory}/macvendor.db";
          log.ftl = "${cfg.logDirectory}/FTL.log";
          log.dnsmasq = "${cfg.logDirectory}/pihole.log";
          log.webserver = "${cfg.logDirectory}/webserver.log";
        };

        webserver.tls.cert = "${cfg.stateDirectory}/tls.pem";
      }

      (lib.optionalAttrs cfg.useDnsmasqConfig {
        misc.dnsmasq_lines = lib.pipe config.services.dnsmasq.configFile [
          builtins.readFile
          (lib.strings.splitString "\n")
          (builtins.filter (s: s != ""))
        ];
      })
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.configDirectory} 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDirectory} 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.logDirectory} 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services = {
      pihole-ftl =
        let
          setupService = config.systemd.services.pihole-ftl-setup.name;
        in
        {
          description = "Pi-hole FTL";

          after = [ "network.target" ];
          before = [ setupService ];

          wantedBy = [ "multi-user.target" ];
          wants = [ setupService ];

          environment = {
            # Currently unused, but allows the service to be reloaded
            # automatically when the config is changed.
            PIHOLE_CONFIG = settingsFile;

            # pihole is executed by the /actions/gravity API endpoint
            PATH = lib.mkForce (
              lib.makeBinPath [
                cfg.piholePackage
              ]
            );
          };

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            AmbientCapabilities = [
              "CAP_NET_BIND_SERVICE"
              "CAP_NET_RAW"
              "CAP_NET_ADMIN"
              "CAP_SYS_NICE"
              "CAP_IPC_LOCK"
              "CAP_CHOWN"
              "CAP_SYS_TIME"
            ];
            ExecStart = "${getExe cfg.package} no-daemon";
            Restart = "on-failure";
            RestartSec = 1;
            # Hardening
            NoNewPrivileges = true;
            PrivateTmp = true;
            PrivateDevices = true;
            DevicePolicy = "closed";
            ProtectSystem = "strict";
            ProtectHome = "read-only";
            ProtectControlGroups = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ReadWritePaths = [
              cfg.configDirectory
              cfg.stateDirectory
              cfg.logDirectory
            ];
            RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            MemoryDenyWriteExecute = true;
            LockPersonality = true;
          };
        };

      pihole-ftl-setup = {
        description = "Pi-hole FTL setup";
        enable = builtins.length cfg.lists > 0;

        # Wait for network so lists can be downloaded
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;

          # Hardening
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ReadWritePaths = [
            cfg.configDirectory
            cfg.stateDirectory
            cfg.logDirectory
          ];
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
        };
        script = import ./pihole-ftl-setup-script.nix {
          inherit
            cfg
            config
            lib
            pkgs
            ;
        };
      };

      pihole-ftl-log-deleter = mkIf cfg.queryLogDeleter.enable {
        description = "Pi-hole FTL DNS query log deleter";
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
          # Hardening
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ReadWritePaths = [ cfg.stateDirectory ];
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
        };
        script =
          let
            days = toString cfg.queryLogDeleter.age;
            database = cfg.settings.files.database;
          in
          ''
            set -euo pipefail

            # Avoid creating an empty database file if it doesn't yet exist
            if [ ! -f "${database}" ]; then
              exit 0;
            fi

            echo "Deleting query logs older than ${days} days"
            ${getExe cfg.package} sqlite3 "${database}" "DELETE FROM query_storage WHERE timestamp <= CAST(strftime('%s', date('now', '-${days} day')) AS INT); select changes() from query_storage limit 1"
          '';
      };
    };

    systemd.timers.pihole-ftl-log-deleter = mkIf cfg.queryLogDeleter.enable {
      description = "Pi-hole FTL DNS query log deleter";
      before = [
        config.systemd.services.pihole-ftl.name
        config.systemd.services.pihole-ftl-setup.name
      ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.queryLogDeleter.interval;
        Unit = "pihole-ftl-log-deleter.service";
      };
    };

    networking.firewall = lib.mkMerge [
      (mkIf cfg.openFirewallDNS {
        allowedUDPPorts = [ 53 ];
        allowedTCPPorts = [ 53 ];
      })

      (mkIf cfg.openFirewallDHCP {
        allowedUDPPorts = [ 67 ];
      })

      (mkIf cfg.openFirewallWebserver {
        allowedTCPPorts = lib.pipe cfg.settings.webserver.port [
          (lib.splitString ",")
          (map (
            port:
            lib.pipe port [
              (builtins.split "[[:alpha:]]+")
              builtins.head
              lib.toInt
            ]
          ))
        ];
      })
    ];

    users.users.${cfg.user} = {
      group = cfg.group;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

    environment.etc."pihole/pihole.toml" = {
      source = settingsFile;
      user = cfg.user;
      group = cfg.group;
      mode = "400";
    };

    environment.systemPackages = [ cfg.pihole ];

    services.logrotate.settings.pihole-ftl = {
      enable = true;
      files = [ "${cfg.logDirectory}/FTL.log" ];
    };
  };

  meta = {
    doc = ./pihole-ftl.md;
    maintainers = with lib.maintainers; [ averyvigolo ];
  };
}
