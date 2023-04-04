{ pkgs
, lib
, config
, ...
}:

with {
  inherit (lib)
    elemAt
    getExe
    mdDoc
    mkEnableOption
    mkIf
    mkOption
    strings
    types;
};

let
  cfg = config.services.pihole-ftl;
  confFile = "${cfg.stateDirectory}/pihole-FTL.conf";

  ftlConf = (pkgs.formats.keyValue { }).generate "pihole-FTL.conf" ({
    PRIVACYLEVEL = cfg.privacyLevel;
  } // cfg.extraConfig);

  # Keys in setupVars.conf, reverse-engineered from the installation script,
  # adapted to use the dnsmasq module settings.
  setupVars =
    let
      dnsmasqConfig = config.services.dnsmasq;
      uiConfig = config.services.pihole-web;
      settings = dnsmasqConfig.settings;
      boolSetting = attribute: if lib.hasAttr attribute settings then (elemAt (lib.getAttr attribute settings) 0) else false;
      dhcpEnabled = lib.hasAttr "dhcp-range" settings;
    in
    {
      DHCP_ACTIVE = false;
      DNSMASQ_LISTENING =
        if boolSetting "local-service" then "local"
        else if boolSetting "bind-interfaces" then "bind"
        else "all";
      DNSSEC = boolSetting "dnssec";
      DNS_BOGUS_PRIV = boolSetting "bogus-priv";
      DNS_FQDN_REQUIRED = boolSetting "domain-needed";
      QUERY_LOGGING = boolSetting "log-queries";
      TEMPERATUREUNIT = uiConfig.temperatureUnit;
      WEBTHEME = uiConfig.theme;
    }
    // lib.listToAttrs (lib.imap1 (i: ip: lib.nameValuePair "PIHOLE_DNS_${toString i}" ip) settings.server)
    // lib.optionalAttrs dhcpEnabled (
      let
        # Ranges will be in the pattern "<start-ip>,<end-ip>,<lease-time>"
        splitIPv4 = builtins.split "\\.";
        isIPv4Address = range: builtins.length (splitIPv4 range) == 7;
        ranges = map (builtins.split ",") settings.dhcp-range;
        range = lib.head (lib.filter (range: isIPv4Address (elemAt range 0)) ranges);
      in
      {
        DHCP_ACTIVE = true;
        DHCP_END = elemAt (splitIPv4 (elemAt range 2)) 6;
        # Lease time can be "infinite", or a number and optional suffix. No suffix means seconds.
        # If not specified, defaults to 1 hour.
        # pihole expects lease time to be in hours.
        # If infinite is used, set it to 0.
        DHCP_LEASE_TIME =
          if (builtins.length range) < 4 then 1
          else
            let
              match = builtins.match "([[:digit:]]+)(m|h|d|w)?" (elemAt range 4);
              multipliers = rec {
                w = d * 7;
                d = h * 24;
                h = 1;
                m = h / 60.0;
                s = m / 60.0;
              };
              suffix = let value = (elemAt match 1); in if value != null then value else "s";
              multiplier = lib.getAttr suffix multipliers;
            in
            if match != null then (strings.toInt (elemAt match 0)) * multiplier
            else 0;
        DHCP_ROUTER = config.networking.defaultGateway.address;
        DHCP_START = elemAt (splitIPv4 (elemAt range 0)) 6;
        DHCP_rapid_commit = boolSetting "dhcp-rapid-commit";
      }
    )
    // cfg.extraSetupVars;

  setupVarsConf = (pkgs.formats.keyValue { }).generate "setupVars.conf" setupVars;

  dnsmasqConf = config.services.dnsmasq.configFile;

  # Check the syntax of the config file. Note that this does not check that all options are all valid
  validatedDnsmasqConf = pkgs.runCommand "validated-dnsmasq.conf" {} ''
    ${getExe cfg.package} -- --test --conf-file=${dnsmasqConf} > out 2>&1 || true
    if ! grep -q "syntax check OK." out; then
      echo pihole-FTL config validation failed.
      echo config was ${dnsmasqConf}.
      echo pihole-FTL output:
      cat out
      exit 1
    fi
    cp ${dnsmasqConf} $out
  '';

  pihole-script = pkgs.writeScriptBin "pihole" ''
    cd ${cfg.package}
    sudo=exec
    if [[ "$USER" != '${cfg.user}' ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user}'
    fi
    $sudo ${getExe cfg.pihole-package} "$@"
  '';
in
{
  options.services.pihole-ftl = {
    enable = mkEnableOption (mdDoc "Pi-hole FTL");

    package = lib.mkPackageOptionMD pkgs "pihole-ftl" {};

    pihole-package = lib.mkPackageOptionMD pkgs "pihole" {};

    privacyLevel = mkOption {
      type = types.numbers.between 0 3;
      description = mdDoc ''
        Level of detail in generated statistics. 0 enables full statistics, 3
        shows only anonymous statistics.

        See [the documentation](https://docs.pi-hole.net/ftldns/privacylevels).

        Also see services.dnsmasq.settings.log-queries to completely disable
        query logging.
      '';
      default = 0;
      example = "3";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Open ports in the firewall for Pi-hole FTL.";
    };

    stateDirectory = mkOption {
      type = types.path;
      default = "/etc/pihole";
      internal = true;
      description = ''
        Path for any pihole state files.
        pihole does not support any path other than /etc/pihole.
      '';
    };

    logDirectory = mkOption {
      type = types.path;
      default = "/var/log/pihole";
      internal = true;
      description = ''
        Path for pihole log files.
        pihole does not support any path other than /var/log/pihole.
      '';
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = { };
      description = mdDoc ''
        Additional configuration values for Pi-hole FTL.

        See the upstream [documentation](https://docs.pi-hole.net/ftldns/configfile)
      '';
      example = {
        NICE = 0;
        DEBUG_ALL = true;
      };
    };

    extraSetupVars = mkOption {
      type = types.attrs;
      default = { };
      description = mdDoc ''
        Additional configuration values for Pi-hole setupVars.conf file.
      '';
      example = {
        API_QUERY_LOG_SHOW = "blockedonly";
      };
    };

    pihole = mkOption {
      type = types.package;
      default = pihole-script;
      internal = true;
      description = mdDoc "Pi-hole admin script";
    };

    adlists =
      let
        adlistType = types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              description = mdDoc "URL of the adlist";
            };
            comment = mkOption {
              type = types.str;
              description = mdDoc "Comment to attach to the adlist";
              default = "";
            };
          };
          default = { };
          description = mdDoc "Pi-hole adlist definition";
        };
      in
      mkOption {
        type = with types; listOf attrs;
        description = mdDoc "URLs of blocklists to use";
        default = [ ];
        example = [{ url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"; }];
      };

    user = mkOption {
      type = types.str;
      default = "pihole";
      description = mdDoc "User to run the service as.";
    };

    group = mkOption {
      type = types.str;
      default = "pihole";
      description = mdDoc "Group to run the service as.";
    };

    queryLogDeleter = {
      enable = mkEnableOption (mdDoc "Pi-hole FTL DNS query log deleter");

      age = mkOption {
        type = types.int;
        default = 90;
        description = mdDoc ''
          Delete DNS query logs older than this many days, if
          [](#opt-services.pihole-ftl.queryLogDeleter.enable) is on.
        '';
      };

      interval = mkOption {
        type = types.str;
        default = "weekly";
        description = mdDoc ''
          How often the query log deleter is run. See systemd.time(7) for more
          information about the format.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = !config.services.dnsmasq.enable;
        message = "pihole-ftl conflicts with dnsmasq. Please disable one of them";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDirectory} 0700 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.logDirectory} 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services = {
      pihole-ftl-setup = {
        description = "Pi-hole FTL setup";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          inherit (config.systemd.services.pihole-ftl.serviceConfig) User Group;
        };
        script =
          let
            escapeSQL = builtins.replaceStrings [ "'" ] [ "''" ];
            pihole = getExe cfg.pihole;
          in
          ''
            set -euo pipefail

            # If the database doesn't exist, it needs to be created with gravity.sh
            if [ ! -f '${cfg.stateDirectory}'/gravity.db ]; then
              DONT_RESTART_FTL=1 ${pihole} -g
            fi

            ${builtins.concatStringsSep ""
              (map (list: ''${pihole} -a adlist add \
                ${strings.escapeShellArg (escapeSQL list.url)} \
                ${strings.escapeShellArg (escapeSQL list.comment)}'')
              cfg.adlists)}

            # Run gravity.sh to load any new adlists
            DONT_RESTART_FTL=1 ${pihole} -g
          '';
      };

      pihole-ftl = {
        description = "Pi-hole FTL";

        after = [ "network.target" "pihole-ftl-setup.service" ];
        requires = [ "pihole-ftl-setup.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          AmbientCapabilities = [
            "CAP_NET_BIND_SERVICE"
            "CAP_NET_RAW"
            "CAP_NET_ADMIN"
            "CAP_SYS_NICE"
          ];
          ExecStart = "${getExe cfg.package} no-daemon -- --conf-file=${validatedDnsmasqConf}";
          # HUP reloads configuration and lists. Used by the unpatched pihole script.
          ExecReload = "${pkgs.procps}/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
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
          ReadWritePaths = [ cfg.stateDirectory cfg.logDirectory ];
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
        };
      };

      pihole-ftl-log-deleter = mkIf cfg.queryLogDeleter.enable {
        description = "Pi-hole FTL DNS query log deleter";
        serviceConfig = let ftlCfg = config.systemd.services.pihole-ftl; in {
          Type = "oneshot";
          User = ftlCfg.serviceConfig.User;
          Group = ftlCfg.serviceConfig.Group;
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
            database = "${cfg.stateDirectory}/pihole-FTL.db";
          in
          ''
          set -euo pipefail

          echo "Deleting query logs older than ${days} days"
          ${getExe cfg.package} sqlite3 "${database}" "DELETE FROM query_storage WHERE timestamp <= CAST(strftime('%s', date('now', '-${days} day')) AS INT); select changes() from query_storage limit 1"

          echo 'Reloading pihole-FTL'
          ${pkgs.systemd}/bin/systemctl reload pihole-ftl
          '';
        };
    };

    systemd.timers.pihole-ftl-log-deleter = mkIf cfg.queryLogDeleter.enable {
      description = "Pi-hole FTL DNS query log deleter";
      before = [ "pihole-ftl.service" "pihole-ftl-setup.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.queryLogDeleter.interval;
        Unit = "pihole-ftl-log-deleter.service";
      };
    };

    services.dnsmasq.settings.dhcp-leasefile = "${cfg.stateDirectory}/dhcp.leases";

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };

    users.users.${cfg.user} = {
      group = cfg.group;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

    environment.etc."pihole/setupVars.conf" = {
      source = setupVarsConf;
      user = cfg.user;
      group = cfg.group;
      mode = "400";
    };

    environment.etc."pihole/pihole-FTL.conf" = {
      source = ftlConf;
      user = cfg.user;
      group = cfg.group;
      mode = "400";
    };

    environment.systemPackages = [ pihole-script ];

    services.logrotate.settings.pihole-ftl = {
      enable = true;
      files = [ "/var/log/pihole/FTL.log" ];
    };

    # Required by gravity script
    networking.hosts."127.0.0.1" = [ "pi.hole" ];

    # The log deleter needs to reload pihole-ftl
    security.polkit.extraConfig = mkIf cfg.queryLogDeleter.enable ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "pihole-ftl.service" &&
              action.lookup("verb") == "reload" &&
              subject.user == "${cfg.user}") {
              return polkit.Result.YES;
          }
      });
    '';
  };

  meta = {
    doc = ./pihole-ftl.md;
    maintainers = with lib.maintainers; [ williamvds ];
  };
}
