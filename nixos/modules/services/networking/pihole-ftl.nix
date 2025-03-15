{
  pkgs,
  lib,
  config,
  ...
}:

with {
  inherit (lib)
    elemAt
    getExe
    mkEnableOption
    mkIf
    mkOption
    strings
    types
    ;
};

let
  cfg = config.services.pihole-ftl;
  confFile = "${cfg.stateDirectory}/pihole-FTL.conf";

  ftlConf = (pkgs.formats.keyValue { }).generate "pihole-FTL.conf" (
    {
      PRIVACYLEVEL = cfg.privacyLevel;
    }
    // cfg.extraConfig
  );

  # Keys in setupVars.conf, reverse-engineered from the installation script,
  # adapted to use the dnsmasq module settings.
  setupVars =
    let
      dnsmasqConfig = config.services.dnsmasq;
      uiConfig = config.services.pihole-web;
      settings = dnsmasqConfig.settings;
      boolSetting =
        attribute:
        if lib.hasAttr attribute settings then (elemAt (lib.getAttr attribute settings) 0) else false;
      dhcpEnabled = lib.hasAttr "dhcp-range" settings;
    in
    {
      DHCP_ACTIVE = false;
      DNSMASQ_LISTENING =
        if boolSetting "local-service" then
          "local"
        else if boolSetting "bind-interfaces" then
          "bind"
        else
          "all";
      DNSSEC = boolSetting "dnssec";
      DNS_BOGUS_PRIV = boolSetting "bogus-priv";
      DNS_FQDN_REQUIRED = boolSetting "domain-needed";
      QUERY_LOGGING = boolSetting "log-queries";
      TEMPERATUREUNIT = uiConfig.temperatureUnit;
      WEBTHEME = uiConfig.theme;
    }
    // lib.listToAttrs (
      lib.imap1 (i: ip: lib.nameValuePair "PIHOLE_DNS_${toString i}" ip) settings.server
    )
    # The following options are inconsequential because there is no state. But
    # they're displayed in the web UI (pihole-adminlte), so make a best effort
    # to fill them in
    // lib.optionalAttrs dhcpEnabled (
      let
        # Ranges will be in the pattern
        # [tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>[,<netmask>[,<broadcast>]]][,<lease time>]
        # Try to find the rough pattern "<start-ip>,[end-ip],...,[lease-time]"
        ipv4Pattern = "([0-9.]+)";
        getComponents = range: builtins.filter (x: x != [ ]) (builtins.split "," range);
        # Lease time can be "infinite", or a number and optional suffix. No suffix means seconds.
        # If not specified, dnsmasq defaults to 1 hour for IPv4.
        # pihole expects lease time to be in hours.
        # If infinite is used, set it to 0.
        parseLeaseTime =
          leaseTime:
          let
            match = builtins.match "([[:digit:]]+)(m|h|d|w)?" leaseTime;
            multipliers = rec {
              w = d * 7;
              d = h * 24;
              h = 1;
              m = h / 60.0;
              s = m / 60.0;
            };
            suffix =
              let
                value = (elemAt match 1);
              in
              if value != null then value else "s";
            multiplier = lib.getAttr suffix multipliers;
          in
          if leaseTime == "infinite" then
            0
          else if match != null then
            (strings.toInt (elemAt match 0)) * multiplier
          else
            0;
        parseDhcpRange =
          range:
          let
            components = getComponents range;
            addresses = map (x: elemAt x 0) (
              builtins.filter (x: x != null) (map (builtins.match ipv4Pattern) components)
            );
          in
          if (addresses == [ ]) then
            null
          else
            {
              start = (builtins.head addresses);
              end = if builtins.length addresses > 1 then elemAt addresses 1 else null;
              leaseTime =
                let
                  last = lib.lists.last components;
                in
                if (builtins.match ipv4Pattern last) != null then null else parseLeaseTime last;
            };
        ipv4Range = lib.lists.findFirst (x: x != null) null (map parseDhcpRange settings.dhcp-range);
      in
      if ipv4Range == null then
        { }
      else
        {
          DHCP_ACTIVE = true;
          DHCP_ROUTER = config.networking.defaultGateway.address;
          DHCP_rapid_commit = boolSetting "dhcp-rapid-commit";
        }
        // lib.optionalAttrs (ipv4Range != null) {
          DHCP_START = ipv4Range.start;
          DHCP_END = if ipv4Range.end != null then ipv4Range.end else "";
          DHCP_LEASE_TIME = if ipv4Range.leaseTime != null then ipv4Range.leaseTime else "1";
        }
    )
    // cfg.extraSetupVars;

  setupVarsConf = (pkgs.formats.keyValue { }).generate "setupVars.conf" setupVars;

  dnsmasqConf = config.services.dnsmasq.configFile;

  # Check the syntax of the config file. Note that this does not check that all options are valid
  validatedDnsmasqConf = pkgs.runCommand "validated-dnsmasq.conf" { } ''
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
    enable = mkEnableOption "Pi-hole FTL";

    package = lib.mkPackageOption pkgs "pihole-ftl" { };

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
      example = "3";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open ports in the firewall for Pi-hole FTL.";
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
      description = ''
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
      description = ''
        Additional configuration values for Pi-hole setupVars.conf file.
      '';
      example = {
        API_QUERY_LOG_SHOW = "blockedonly";
      };
    };

    pihole-package = lib.mkPackageOption pkgs "pihole" { };

    pihole = mkOption {
      type = types.package;
      default = pihole-script;
      internal = true;
      description = "Pi-hole admin script";
    };

    adlists =
      let
        adlistType = types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              description = "URL of the adlist";
            };
            comment = mkOption {
              type = types.str;
              description = "Comment to attach to the adlist";
              default = "";
            };
          };
          default = { };
          description = "Pi-hole adlist definition";
        };
      in
      mkOption {
        type = with types; listOf attrs;
        description = "URLs of blocklists to use";
        default = [ ];
        example = [ { url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"; } ];
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
        # Wait for network so adlists can be downloaded
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
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

            # Patched in for NixOS - ensure the gravity script doesn't start
            # the main Pi-hole service in this setup service.
            export DONT_RESTART_FTL=1

            # If the database doesn't exist, it needs to be created with gravity.sh
            if [ ! -f '${cfg.stateDirectory}'/gravity.db ]; then
              ${pihole} -g
            fi

            ${builtins.concatStringsSep "\n\n" (
              map (list: ''
                ${pihole} -a adlist add \
                                ${strings.escapeShellArg (escapeSQL list.url)} \
                                ${strings.escapeShellArg (escapeSQL list.comment)}'') cfg.adlists
            )}

            # Run gravity.sh to load any new adlists
            ${pihole} -g
          '';
      };

      pihole-ftl = {
        description = "Pi-hole FTL";

        after = [
          "network.target"
          "pihole-ftl-setup.service"
        ];
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
          # Remove any leftover shared memory files from previous processes
          ExecStartPre = "/run/current-system/sw/bin/sh -c '/run/current-system/sw/bin/rm -f /dev/shm/FTL-*'";
          ExecStart = "${getExe cfg.package} no-daemon -- --conf-file=${validatedDnsmasqConf}";
          # HUP reloads configuration and lists. Used by the unpatched pihole script.
          ExecReload = "${pkgs.procps}/bin/kill -HUP $MAINPID";
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

      pihole-ftl-log-deleter = mkIf cfg.queryLogDeleter.enable {
        description = "Pi-hole FTL DNS query log deleter";
        serviceConfig =
          let
            ftlCfg = config.systemd.services.pihole-ftl;
          in
          {
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
      before = [
        "pihole-ftl.service"
        "pihole-ftl-setup.service"
      ];
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
