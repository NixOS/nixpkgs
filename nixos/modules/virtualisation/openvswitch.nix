# Systemd services for openvswitch

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.vswitch;

in

{

  options = {

    virtualisation.vswitch.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
        Enable Open vSwitch. A configuration 
        daemon (ovs-server) will be started.
        '';
    };


    virtualisation.vswitch.package = mkOption {
      type = types.package;
      default = pkgs.openvswitch;
      description =
        ''
        Open vSwitch package to use.
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
      installPhase = 
        ''
        ensureDir $out/
        '';
    };

  in {

    environment.systemPackages = [ cfg.package ]; 

    boot.kernelModules = [ "tun" "openvswitch" ];

    boot.extraModulePackages = [ cfg.package ];

    systemd.services.ovsdb = {
      description = "Open_vSwitch Database Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      wants = [ "vswitchd.service" ];
      path = [ cfg.package ];
      restartTriggers = [ db cfg.package ];
      # Create the config database
      preStart = 
        ''
        mkdir -p ${runDir}
        mkdir -p /var/db/openvswitch
        chmod +w /var/db/openvswitch
        if [[ ! -e /var/db/openvswitch/conf.db ]]; then
          ${cfg.package}/bin/ovsdb-tool create \
            "/var/db/openvswitch/conf.db" \
            "${cfg.package}/share/openvswitch/vswitch.ovsschema"
        fi
        chmod -R +w /var/db/openvswitch
        '';
      serviceConfig.ExecStart = 
        ''
        ${cfg.package}/bin/ovsdb-server \
          --remote=punix:${runDir}/db.sock \
          --private-key=db:Open_vSwitch,SSL,private_key \
          --certificate=db:Open_vSwitch,SSL,certificate \
          --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
          --unixctl=ovsdb.ctl.sock \
          /var/db/openvswitch/conf.db
        '';       
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 3;
      postStart =
        ''
        ${cfg.package}/bin/ovs-vsctl --timeout 3 --retry --no-wait init
        '';

    };

    systemd.services.vswitchd = {
      description = "Open_vSwitch Daemon";
      bindsTo = [ "ovsdb.service" ];
      after = [ "ovsdb.service" ];
      path = [ cfg.package ];
      serviceConfig.ExecStart = ''${cfg.package}/bin/ovs-vswitchd'';
    };

  });

}
