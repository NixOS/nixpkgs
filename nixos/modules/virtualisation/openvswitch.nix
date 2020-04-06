# Systemd services for openvswitch

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.vswitch;

in {

  options.virtualisation.vswitch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable Open vSwitch. A configuration daemon (ovs-server)
        will be started.
        '';
    };

    resetOnStart = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to reset the Open vSwitch configuration database to a default
        configuration on every start of the systemd <literal>ovsdb.service</literal>.
        '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.openvswitch;
      defaultText = "pkgs.openvswitch";
      description = ''
        Open vSwitch package to use.
      '';
    };

    ipsec = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to start racoon service for openvswitch.
        Supported only if openvswitch version is less than 2.6.0.
        Use <literal>virtualisation.vswitch.package = pkgs.openvswitch-lts</literal>
        for a version that supports ipsec over GRE.
      '';
    };
  };

  config = mkIf cfg.enable (let

    # Where the communication sockets live
    runDir = "/run/openvswitch";

    # The path to the an initialized version of the database
    db = pkgs.stdenv.mkDerivation {
      name = "vswitch.db";
      dontUnpack = true;
      buildPhase = "true";
      buildInputs = with pkgs; [
        cfg.package
      ];
      installPhase = "mkdir -p $out";
    };

  in (mkMerge [{

    environment.systemPackages = [ cfg.package pkgs.ipsecTools ];

    boot.kernelModules = [ "tun" "openvswitch" ];

    boot.extraModulePackages = [ cfg.package ];

    systemd.services.ovsdb = {
      description = "Open_vSwitch Database Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      path = [ cfg.package ];
      restartTriggers = [ db cfg.package ];
      # Create the config database
      preStart =
        ''
        mkdir -p ${runDir}
        mkdir -p /var/db/openvswitch
        chmod +w /var/db/openvswitch
        ${optionalString cfg.resetOnStart "rm -f /var/db/openvswitch/conf.db"}
        if [[ ! -e /var/db/openvswitch/conf.db ]]; then
          ${cfg.package}/bin/ovsdb-tool create \
            "/var/db/openvswitch/conf.db" \
            "${cfg.package}/share/openvswitch/vswitch.ovsschema"
        fi
        chmod -R +w /var/db/openvswitch
        if ${cfg.package}/bin/ovsdb-tool needs-conversion /var/db/openvswitch/conf.db | grep -q "yes"
        then
          echo "Performing database upgrade"
          ${cfg.package}/bin/ovsdb-tool convert /var/db/openvswitch/conf.db
        else
          echo "Database already up to date"
        fi
        '';
      serviceConfig = {
        ExecStart =
          ''
          ${cfg.package}/bin/ovsdb-server \
            --remote=punix:${runDir}/db.sock \
            --private-key=db:Open_vSwitch,SSL,private_key \
            --certificate=db:Open_vSwitch,SSL,certificate \
            --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
            --unixctl=ovsdb.ctl.sock \
            --pidfile=/run/openvswitch/ovsdb.pid \
            --detach \
            /var/db/openvswitch/conf.db
          '';
        Restart = "always";
        RestartSec = 3;
        PIDFile = "/run/openvswitch/ovsdb.pid";
        # Use service type 'forking' to correctly determine when ovsdb-server is ready.
        Type = "forking";
      };
      postStart = ''
        ${cfg.package}/bin/ovs-vsctl --timeout 3 --retry --no-wait init
      '';
    };

    systemd.services.ovs-vswitchd = {
      description = "Open_vSwitch Daemon";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "ovsdb.service" ];
      after = [ "ovsdb.service" ];
      path = [ cfg.package ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/ovs-vswitchd \
          --pidfile=/run/openvswitch/ovs-vswitchd.pid \
          --detach
        '';
        PIDFile = "/run/openvswitch/ovs-vswitchd.pid";
        # Use service type 'forking' to correctly determine when vswitchd is ready.
        Type = "forking";
        Restart = "always";
        RestartSec = 3;
      };
    };

  }
  (mkIf (cfg.ipsec && (versionOlder cfg.package.version "2.6.0")) {
    services.racoon.enable = true;
    services.racoon.configPath = "${runDir}/ipsec/etc/racoon/racoon.conf";

    networking.firewall.extraCommands = ''
      iptables -I INPUT -t mangle -p esp -j MARK --set-mark 1/1
      iptables -I INPUT -t mangle -p udp --dport 4500 -j MARK --set-mark 1/1
    '';

    systemd.services.ovs-monitor-ipsec = {
      description = "Open_vSwitch Ipsec Daemon";
      wantedBy = [ "multi-user.target" ];
      requires = [ "ovsdb.service" ];
      before = [ "vswitchd.service" "racoon.service" ];
      environment.UNIXCTLPATH = "/tmp/ovsdb.ctl.sock";
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/ovs-monitor-ipsec \
            --root-prefix ${runDir}/ipsec \
            --pidfile /run/openvswitch/ovs-monitor-ipsec.pid \
            --monitor --detach \
            unix:/run/openvswitch/db.sock
        '';
        PIDFile = "/run/openvswitch/ovs-monitor-ipsec.pid";
        # Use service type 'forking' to correctly determine when ovs-monitor-ipsec is ready.
        Type = "forking";
      };

      preStart = ''
        rm -r ${runDir}/ipsec/etc/racoon/certs || true
        mkdir -p ${runDir}/ipsec/{etc/racoon,etc/init.d/,usr/sbin/}
        ln -fs ${pkgs.ipsecTools}/bin/setkey ${runDir}/ipsec/usr/sbin/setkey
        ln -fs ${pkgs.writeScript "racoon-restart" ''
        #!${pkgs.runtimeShell}
        /run/current-system/sw/bin/systemctl $1 racoon
        ''} ${runDir}/ipsec/etc/init.d/racoon
      '';
    };
  })]));

  meta.maintainers = with maintainers; [ netixx ];

}
