{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fail2ban;

  fail2banConf = pkgs.writeText "fail2ban.local" cfg.daemonConfig;

  jailConf = pkgs.writeText "jail.local" ''
    [INCLUDES]

    before = paths-nixos.conf

    ${concatStringsSep "\n" (attrValues (flip mapAttrs cfg.jails (name: def:
      optionalString (def != "")
        ''
          [${name}]
          ${def}
        '')))}
  '';

  pathsConf = pkgs.writeText "paths-nixos.conf" ''
    # NixOS

    [INCLUDES]

    before = paths-common.conf

    after  = paths-overrides.local

    [DEFAULT]
  '';

in

{

  ###### interface

  options = {

    services.fail2ban = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to enable the fail2ban service.

          See the documentation of {option}`services.fail2ban.jails`
          for what jails are enabled by default.
        '';
      };

      package = mkOption {
        default = pkgs.fail2ban;
        defaultText = literalExpression "pkgs.fail2ban";
        type = types.package;
        example = literalExpression "pkgs.fail2ban_0_11";
        description = lib.mdDoc "The fail2ban package to use for running the fail2ban service.";
      };

      packageFirewall = mkOption {
        default = config.networking.firewall.package;
        defaultText = literalExpression "config.networking.firewall.package";
        type = types.package;
        description = lib.mdDoc "The firewall package used by fail2ban service. Defaults to the package for your firewall (iptables or nftables).";
      };

      extraPackages = mkOption {
        default = [];
        type = types.listOf types.package;
        example = lib.literalExpression "[ pkgs.ipset ]";
        description = lib.mdDoc ''
          Extra packages to be made available to the fail2ban service. The example contains
          the packages needed by the `iptables-ipset-proto6` action.
        '';
      };

      bantime = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "10m";
        description = lib.mdDoc "Number of seconds that a host is banned.";
      };

      maxretry = mkOption {
        default = 3;
        type = types.ints.unsigned;
        description = lib.mdDoc "Number of failures before a host gets banned.";
      };

      banaction = mkOption {
        default = if config.networking.nftables.enable then "nftables-multiport" else "iptables-multiport";
        defaultText = literalExpression ''if config.networking.nftables.enable then "nftables-multiport" else "iptables-multiport"'';
        type = types.str;
        description = lib.mdDoc ''
          Default banning action (e.g. iptables, iptables-new, iptables-multiport,
          iptables-ipset-proto6-allports, shorewall, etc). It is used to
          define action_* variables. Can be overridden globally or per
          section within jail.local file
        '';
      };

      banaction-allports = mkOption {
        default = if config.networking.nftables.enable then "nftables-allport" else "iptables-allport";
        defaultText = literalExpression ''if config.networking.nftables.enable then "nftables-allport" else "iptables-allport"'';
        type = types.str;
        description = lib.mdDoc ''
          Default banning action (e.g. iptables, iptables-new, iptables-multiport,
          shorewall, etc) for "allports" jails. It is used to define action_* variables. Can be overridden
          globally or per section within jail.local file
        '';
      };

      bantime-increment.enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          "bantime.increment" allows to use database for searching of previously banned ip's to increase
          a default ban time using special formula, default it is banTime * 1, 2, 4, 8, 16, 32 ...
        '';
      };

      bantime-increment.rndtime = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "8m";
        description = lib.mdDoc ''
          "bantime.rndtime" is the max number of seconds using for mixing with random time
          to prevent "clever" botnets calculate exact time IP can be unbanned again
        '';
      };

      bantime-increment.maxtime = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "48h";
        description = lib.mdDoc ''
          "bantime.maxtime" is the max number of seconds using the ban time can reach (don't grows further)
        '';
      };

      bantime-increment.factor = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "4";
        description = lib.mdDoc ''
          "bantime.factor" is a coefficient to calculate exponent growing of the formula or common multiplier,
          default value of factor is 1 and with default value of formula, the ban time grows by 1, 2, 4, 8, 16 ...
        '';
      };

      bantime-increment.formula = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        description = lib.mdDoc ''
          "bantime.formula" used by default to calculate next value of ban time, default value bellow,
          the same ban time growing will be reached by multipliers 1, 2, 4, 8, 16, 32 ...
        '';
      };

      bantime-increment.multipliers = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "1 2 4 8 16 32 64";
        description = lib.mdDoc ''
          "bantime.multipliers" used to calculate next value of ban time instead of formula, corresponding
          previously ban count and given "bantime.factor" (for multipliers default is 1);
          following example grows ban time by 1, 2, 4, 8, 16 ... and if last ban count greater as multipliers count,
          always used last multiplier (64 in example), for factor '1' and original ban time 600 - 10.6 hours
        '';
      };

      bantime-increment.overalljails = mkOption {
        default = null;
        type = types.nullOr types.bool;
        example = true;
        description = lib.mdDoc ''
          "bantime.overalljails" (if true) specifies the search of IP in the database will be executed
          cross over all jails, if false (default), only current jail of the ban IP will be searched
        '';
      };

      ignoreIP = mkOption {
        default = [ ];
        type = types.listOf types.str;
        example = [ "192.168.0.0/16" "2001:DB8::42" ];
        description = lib.mdDoc ''
          "ignoreIP" can be a list of IP addresses, CIDR masks or DNS hosts. Fail2ban will not ban a host which
          matches an address in this list. Several addresses can be defined using space (and/or comma) separator.
        '';
      };

      daemonConfig = mkOption {
        default = ''
          [Definition]
          logtarget = SYSLOG
          socket    = /run/fail2ban/fail2ban.sock
          pidfile   = /run/fail2ban/fail2ban.pid
          dbfile    = /var/lib/fail2ban/fail2ban.sqlite3
        '';
        type = types.lines;
        description = lib.mdDoc ''
          The contents of Fail2ban's main configuration file.  It's
          generally not necessary to change it.
       '';
      };

      extraSettings = mkOption {
        type = with types; attrsOf (oneOf [ bool ints.positive str ]);
        default = {};
        description = lib.mdDoc ''
          Extra default configuration for all jails (i.e. `[DEFAULT]`). See
          <https://github.com/fail2ban/fail2ban/blob/master/config/jail.conf> for an overview.
        '';
        example = literalExpression ''
          {
            findtime = "15m";
          }
        '';
      };

      jails = mkOption {
        default = { };
        example = literalExpression ''
          { apache-nohome-iptables = '''
              # Block an IP address if it accesses a non-existent
              # home directory more than 5 times in 10 minutes,
              # since that indicates that it's scanning.
              filter   = apache-nohome
              action   = iptables-multiport[name=HTTP, port="http,https"]
              logpath  = /var/log/httpd/error_log*
              backend = auto
              findtime = 600
              bantime  = 600
              maxretry = 5
            ''';
           dovecot = '''
             # block IPs which failed to log-in
             # aggressive mode add blocking for aborted connections
             enabled = true
             filter = dovecot[mode=aggressive]
             maxretry = 3
           ''';
          }
        '';
        type = types.attrsOf types.lines;
        description = lib.mdDoc ''
          The configuration of each Fail2ban “jail”.  A jail
          consists of an action (such as blocking a port using
          {command}`iptables`) that is triggered when a
          filter applied to a log file triggers more than a certain
          number of times in a certain time period.  Actions are
          defined in {file}`/etc/fail2ban/action.d`,
          while filters are defined in
          {file}`/etc/fail2ban/filter.d`.

          NixOS comes with a default `sshd` jail;
          for it to work well,
          {option}`services.openssh.logLevel` should be set to
          `"VERBOSE"` or higher so that fail2ban
          can observe failed login attempts.
          This module sets it to `"VERBOSE"` if
          not set otherwise, so enabling fail2ban can make SSH logs
          more verbose.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.bantime-increment.formula == null || cfg.bantime-increment.multipliers == null);
        message = ''
          Options `services.fail2ban.bantime-increment.formula` and `services.fail2ban.bantime-increment.multipliers` cannot be both specified.
        '';
      }
    ];

    warnings = mkIf (!config.networking.firewall.enable && !config.networking.nftables.enable) [
      "fail2ban can not be used without a firewall"
    ];

    environment.systemPackages = [ cfg.package ];

    environment.etc = {
      "fail2ban/fail2ban.local".source = fail2banConf;
      "fail2ban/jail.local".source = jailConf;
      "fail2ban/fail2ban.conf".source = "${cfg.package}/etc/fail2ban/fail2ban.conf";
      "fail2ban/jail.conf".source = "${cfg.package}/etc/fail2ban/jail.conf";
      "fail2ban/paths-common.conf".source = "${cfg.package}/etc/fail2ban/paths-common.conf";
      "fail2ban/paths-nixos.conf".source = pathsConf;
      "fail2ban/action.d".source = "${cfg.package}/etc/fail2ban/action.d/*.conf";
      "fail2ban/filter.d".source = "${cfg.package}/etc/fail2ban/filter.d/*.conf";
    };

    systemd.packages = [ cfg.package ];
    systemd.services.fail2ban = {
      wantedBy = [ "multi-user.target" ];
      partOf = optional config.networking.firewall.enable "firewall.service";

      restartTriggers = [ fail2banConf jailConf pathsConf ];

      path = [ cfg.package cfg.packageFirewall pkgs.iproute2 ] ++ cfg.extraPackages;

      serviceConfig = {
        # Capabilities
        CapabilityBoundingSet = [ "CAP_AUDIT_READ" "CAP_DAC_READ_SEARCH" "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        # Security
        NoNewPrivileges = true;
        # Directory
        RuntimeDirectory = "fail2ban";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "fail2ban";
        StateDirectoryMode = "0750";
        LogsDirectory = "fail2ban";
        LogsDirectoryMode = "0750";
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
      };
    };

    # Add some reasonable default jails.  The special "DEFAULT" jail
    # sets default values for all other jails.
    services.fail2ban.jails.DEFAULT = ''
      # Bantime increment options
      bantime.increment = ${boolToString cfg.bantime-increment.enable}
      ${optionalString (cfg.bantime-increment.rndtime != null) "bantime.rndtime = ${cfg.bantime-increment.rndtime}"}
      ${optionalString (cfg.bantime-increment.maxtime != null) "bantime.maxtime = ${cfg.bantime-increment.maxtime}"}
      ${optionalString (cfg.bantime-increment.factor != null) "bantime.factor = ${cfg.bantime-increment.factor}"}
      ${optionalString (cfg.bantime-increment.formula != null) "bantime.formula = ${cfg.bantime-increment.formula}"}
      ${optionalString (cfg.bantime-increment.multipliers != null) "bantime.multipliers = ${cfg.bantime-increment.multipliers}"}
      ${optionalString (cfg.bantime-increment.overalljails != null) "bantime.overalljails = ${boolToString cfg.bantime-increment.overalljails}"}
      # Miscellaneous options
      ignoreip    = 127.0.0.1/8 ${optionalString config.networking.enableIPv6 "::1"} ${concatStringsSep " " cfg.ignoreIP}
      ${optionalString (cfg.bantime != null) ''
        bantime     = ${cfg.bantime}
      ''}
      maxretry    = ${toString cfg.maxretry}
      backend     = systemd
      # Actions
      banaction   = ${cfg.banaction}
      banaction_allports = ${cfg.banaction-allports}
      ${optionalString (cfg.extraSettings != {}) ''
        # Extra settings
        ${generators.toKeyValue {} cfg.extraSettings}
      ''}
    '';
    # Block SSH if there are too many failing connection attempts.
    # Benefits from verbose sshd logging to observe failed login attempts,
    # so we set that here unless the user overrode it.
    services.openssh.settings.LogLevel = lib.mkDefault "VERBOSE";
    services.fail2ban.jails.sshd = mkDefault ''
      enabled = true
      port    = ${concatMapStringsSep "," (p: toString p) config.services.openssh.ports}
    '';
  };
}
