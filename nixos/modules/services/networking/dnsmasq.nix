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
        description = ''
          Whether to run dnsmasq.
        '';
      };

      resolveLocalQueries = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether dnsmasq should resolve local queries (i.e. add 127.0.0.1 to
          /etc/resolv.conf).
        '';
      };

      servers = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "8.8.8.8" "8.8.4.4" ];
        description = ''
          The DNS servers which dnsmasq should query.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration directives that should be added to
          <literal>dnsmasq.conf</literal>.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.dnsmasq.enable {

    networking.nameservers =
      optional cfg.resolveLocalQueries "127.0.0.1";

    services.dbus.packages = [ dnsmasq ];

    users.extraUsers = singleton {
      name = "dnsmasq";
      uid = config.ids.uids.dnsmasq;
      description = "Dnsmasq daemon user";
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
        };
        restartTriggers = [ config.environment.etc.hosts.source ];
    };

  };

}
