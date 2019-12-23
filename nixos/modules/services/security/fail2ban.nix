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
        description = "Whether to enable the fail2ban service.";
      };

      package = mkOption {
        default = pkgs.fail2ban;
        type = types.package;
        example = "pkgs.fail2ban_0_11";
        description = "The fail2ban package to use for running the fail2ban service.";
      };

      packageFirewall = mkOption {
        default = pkgs.iptables;
        type = types.package;
        example = "pkgs.nftables";
        description = "The firewall package used by fail2ban service.";
      };

      banaction = mkOption {
        default = "iptables-multiport";
        type = types.str;
        example = "nftables-multiport";
        description = ''
          Default banning action (e.g. iptables, iptables-new, iptables-multiport,
          shorewall, etc) It is used to define action_* variables. Can be overridden
          globally or per section within jail.local file
        '';
      };

      banaction-allports = mkOption {
        default = "iptables-allport";
        type = types.str;
        example = "nftables-allport";
        description = ''
          Default banning action (e.g. iptables, iptables-new, iptables-multiport,
          shorewall, etc) It is used to define action_* variables. Can be overridden
          globally or per section within jail.local file
        '';
      };

      bantime-increment.enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Allows to use database for searching of previously banned ip's to increase
          a default ban time using special formula, default it is banTime * 1, 2, 4, 8, 16, 32...
        '';
      };

      bantime-increment.rndtime = mkOption {
        default = "4m";
        type = types.str;
        example = "8m";
        description = ''
          "bantime-increment.rndtime" is the max number of seconds using for mixing with random time
          to prevent "clever" botnets calculate exact time IP can be unbanned again
        '';
      };

      bantime-increment.maxtime = mkOption {
        default = "10h";
        type = types.str;
        example = "48h";
        description = ''
          "bantime-increment.maxtime" is the max number of seconds using the ban time can reach (don't grows further)
        '';
      };

      bantime-increment.factor = mkOption {
        default = "1";
        type = types.str;
        example = "4";
        description = ''
          "bantime-increment.factor" is a coefficient to calculate exponent growing of the formula or common multiplier,
          default value of factor is 1 and with default value of formula, the ban time grows by 1, 2, 4, 8, 16 ...
        '';
      };

      bantime-increment.formula = mkOption {
        default = "ban.Time * (1<<(ban.Count if ban.Count<20 else 20)) * banFactor";
        type = types.str;
        example = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        description = ''
          "bantime-increment.formula" used by default to calculate next value of ban time, default value bellow,
          the same ban time growing will be reached by multipliers 1, 2, 4, 8, 16, 32...
        '';
      };

      bantime-increment.multipliers = mkOption {
        default = "1 2 4 8 16 32 64";
        type = types.str;
        example = "2 4 16 128";
        description = ''
          "bantime-increment.multipliers" used to calculate next value of ban time instead of formula, coresponding
          previously ban count and given "bantime.factor" (for multipliers default is 1);
          following example grows ban time by 1, 2, 4, 8, 16 ... and if last ban count greater as multipliers count,
          always used last multiplier (64 in example), for factor '1' and original ban time 600 - 10.6 hours
        '';
      };

      bantime-increment.overalljails = mkOption {
        default = false;
        type = types.bool;
        example = true;
        description = ''
          "bantime-increment.overalljails"  (if true) specifies the search of IP in the database will be executed
          cross over all jails, if false (dafault), only current jail of the ban IP will be searched
        '';
      };

      ignoreIP = mkOption {
        default = [ ];
        type = types.listOf types.str;
        example = [ "192.168.0.0/16" "2001:DB8::42" ];
        description = ''
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
        description = ''
          The contents of Fail2ban's main configuration file.  It's
          generally not necessary to change it.
       '';
      };

      jails = mkOption {
        default = { };
        example = literalExample ''
          { apache-nohome-iptables = '''
              # Block an IP address if it accesses a non-existent
              # home directory more than 5 times in 10 minutes,
              # since that indicates that it's scanning.
              filter   = apache-nohome
              action   = iptables-multiport[name=HTTP, port="http,https"]
              logpath  = /var/log/httpd/error_log*
              findtime = 600
              bantime  = 600
              maxretry = 5
            ''';
          }
        '';
        type = types.attrsOf types.lines;
        description = ''
          The configuration of each Fail2ban “jail”.  A jail
          consists of an action (such as blocking a port using
          <command>iptables</command>) that is triggered when a
          filter applied to a log file triggers more than a certain
          number of times in a certain time period.  Actions are
          defined in <filename>/etc/fail2ban/action.d</filename>,
          while filters are defined in
          <filename>/etc/fail2ban/filter.d</filename>.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

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

    systemd.services.fail2ban = {
      description = "Fail2ban Intrusion Prevention System";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      partOf = optional config.networking.firewall.enable "firewall.service";

      restartTriggers = [ fail2banConf jailConf pathsConf ];
      reloadIfChanged = true;

      path = [ cfg.package cfg.packageFirewall pkgs.iproute ];

      unitConfig.Documentation = "man:fail2ban(1)";

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/fail2ban-server -xf start";
        ExecStop = "${cfg.package}/bin/fail2ban-server stop";
        ExecReload = "${cfg.package}/bin/fail2ban-server reload";
        Type = "simple";
        Restart = "on-failure";
        PIDFile = "/run/fail2ban/fail2ban.pid";
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
      ${optionalString cfg.bantime-increment.enable ''
        # Bantime incremental
        bantime.increment    = ${if cfg.bantime-increment.enable then "true" else "false"}
        bantime.maxtime      = ${cfg.bantime-increment.maxtime}
        bantime.factor       = ${cfg.bantime-increment.factor}
        bantime.formula      = ${cfg.bantime-increment.formula}
        bantime.multipliers  = ${cfg.bantime-increment.multipliers}
        bantime.overalljails = ${if cfg.bantime-increment.overalljails then "true" else "false"}
      ''}
      # Miscellaneous options
      ignoreip    = 127.0.0.1/8 ${optionalString config.networking.enableIPv6 "::1"} ${concatStringsSep " " cfg.ignoreIP}
      maxretry    = 3
      backend     = systemd
      # Actions
      banaction   = ${cfg.banaction}
      banaction_allports = ${cfg.banaction-allports}
    '';
    # Block SSH if there are too many failing connection attempts.
    services.fail2ban.jails.sshd = mkDefault ''
      enabled = true
      port    = ${concatMapStringsSep "," (p: toString p) config.services.openssh.ports}
    '';
  };
}
