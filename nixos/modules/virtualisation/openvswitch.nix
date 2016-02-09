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
      '';
    };
  };

  config = mkIf cfg.enable (let

    # Where the communication sockets live
    runDir = "/var/run/openvswitch";

    # Where the config database live (can't be in nix-store)
    stateDir = "/var/db/openvswitch";

    # The path to the an initialized version of the database
    db = pkgs.stdenv.mkDerivation {
      name = "vswitch.db";
      unpackPhase = "true";
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
            --pidfile=/var/run/openvswitch/ovsdb.pid \
            --detach \
            /var/db/openvswitch/conf.db
          '';
        Restart = "always";
        RestartSec = 3;
        PIDFile = "/var/run/openvswitch/ovsdb.pid";
        # Use service type 'forking' to correctly determine when ovsdb-server is ready.
        Type = "forking";
      };
      postStart = ''
        ${cfg.package}/bin/ovs-vsctl --timeout 3 --retry --no-wait init
      '';
    };

    systemd.services.vswitchd = {
      description = "Open_vSwitch Daemon";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "ovsdb.service" ];
      after = [ "ovsdb.service" ];
      path = [ cfg.package ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/ovs-vswitchd \
          --pidfile=/var/run/openvswitch/ovs-vswitchd.pid \
          --detach
        '';
        PIDFile = "/var/run/openvswitch/ovs-vswitchd.pid";
        # Use service type 'forking' to correctly determine when vswitchd is ready.
        Type = "forking";
      };
    };

  }
  (mkIf cfg.ipsec {
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
            --pidfile /var/run/openvswitch/ovs-monitor-ipsec.pid \
            --monitor --detach \
            unix:/var/run/openvswitch/db.sock
        '';
        PIDFile = "/var/run/openvswitch/ovs-monitor-ipsec.pid";
        # Use service type 'forking' to correctly determine when ovs-monitor-ipsec is ready.
        Type = "forking";
      };

      preStart = ''
        rm -r ${runDir}/ipsec/etc/racoon/certs || true
        mkdir -p ${runDir}/ipsec/{etc/racoon,etc/init.d/,usr/sbin/}
        ln -fs ${pkgs.ipsecTools}/bin/setkey ${runDir}/ipsec/usr/sbin/setkey
        ln -fs ${pkgs.writeScript "racoon-restart" ''
        #!${pkgs.stdenv.shell}
        /var/run/current-system/sw/bin/systemctl $1 racoon
        ''} ${runDir}/ipsec/etc/init.d/racoon
      '';
    };
  })]));

}
