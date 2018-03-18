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

  /*
    The sed command removes stateful parts of the config that won't work in this
    derivation.  This method should be fine, as according to dnsmasq(8) (section
    CONFIG FILE) "the format of this file consist of one option per line". It
    does not mention any exceptions to this rule. The only caveat is that this
    will not catch any problems with the config file involving options that
    contain the string /etc/, but it's better than falsely rejecting a valid
    config file.
  */
  configChecked = pkgs.runCommand "dnsmasq-config-checked" {} ''
    sed '/\/etc\//d' ${dnsmasqConf} > dnsmasq.conf

    ${dnsmasq}/bin/dnsmasq --test -C dnsmasq.conf && touch $out
    echo "dnsmasq config file: ${dnsmasqConf}"
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

      alwaysKeepRunning = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, systemd will always respawn dnsmasq even if shut down manually. The default, disabled, will only restart it on error.
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

    system.extraDependencies = [ configChecked ];

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
