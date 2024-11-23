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
        configuration on every start of the systemd `ovsdb.service`.
        '';
    };

    package = mkPackageOption pkgs "openvswitch" { };
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

  in {
    environment.systemPackages = [ cfg.package ];
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

  });

  imports = [
    (mkRemovedOptionModule [ "virtualisation" "vswitch" "ipsec" ] ''
      OpenVSwitch IPSec functionality has been removed, because it depended on racoon,
      which was removed from nixpkgs, because it was abanoded upstream.
    '')
  ];

  meta.maintainers = with maintainers; [ netixx ];

}
