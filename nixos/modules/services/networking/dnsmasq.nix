{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dnsmasq;
  dnsmasq = pkgs.dnsmasq;
  stateDir = "/var/lib/dnsmasq";

  dnsmasqConf = pkgs.writeText "dnsmasq.conf" ''
    dhcp-leasefile=${stateDir}/dnsmasq.leases
    ${optionalString cfg.resolveLocalQueries ''
      conf-file=/etc/dnsmasq-conf.conf
      resolv-file=/etc/dnsmasq-resolv.conf
    ''}
    ${flip concatMapStrings cfg.servers (server: ''
      server=${server}
    '')}
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.dnsmasq = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to run dnsmasq.
        '';
      };

      resolveLocalQueries = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether dnsmasq should resolve local queries (i.e. add 127.0.0.1 to
          /etc/resolv.conf).
        '';
      };

      servers = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "8.8.8.8" "8.8.4.4" ];
        description = lib.mdDoc ''
          The DNS servers which dnsmasq should query.
        '';
      };

      alwaysKeepRunning = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If enabled, systemd will always respawn dnsmasq even if shut down manually. The default, disabled, will only restart it on error.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration directives that should be added to
          `dnsmasq.conf`.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    networking.nameservers =
      optional cfg.resolveLocalQueries "127.0.0.1";

    services.dbus.packages = [ dnsmasq ];

    users.users.dnsmasq = {
      isSystemUser = true;
      group = "dnsmasq";
      description = "Dnsmasq daemon user";
    };
    users.groups.dnsmasq = {};

    networking.resolvconf = mkIf cfg.resolveLocalQueries {
      useLocalResolver = mkDefault true;

      extraConfig = ''
        dnsmasq_conf=/etc/dnsmasq-conf.conf
        dnsmasq_resolv=/etc/dnsmasq-resolv.conf
      '';
    };

    systemd.services.dnsmasq = {
        description = "Dnsmasq Daemon";
        after = [ "network.target" "systemd-resolved.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ dnsmasq ];
        preStart = ''
          mkdir -m 755 -p ${stateDir}
          touch ${stateDir}/dnsmasq.leases
          chown -R dnsmasq ${stateDir}
          touch /etc/dnsmasq-{conf,resolv}.conf
          dnsmasq --test
        '';
        serviceConfig = {
          Type = "dbus";
          BusName = "uk.org.thekelleys.dnsmasq";
          ExecStart = "${dnsmasq}/bin/dnsmasq -k --enable-dbus --user=dnsmasq -C ${dnsmasqConf}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          PrivateTmp = true;
          ProtectSystem = true;
          ProtectHome = true;
          Restart = if cfg.alwaysKeepRunning then "always" else "on-failure";
        };
        restartTriggers = [ config.environment.etc.hosts.source ];
    };
  };
}
