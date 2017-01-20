{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.hyperd;
  vswitch = config.virtualisation.vswitch;
  configFile = pkgs.writeText "hyperd.conf" ''
    Host = unix:///var/run/hyper.sock
    Kernel = ${cfg.kernel}
    Initrd = ${cfg.initrd}
    Bridge = ${cfg.bridge}
    BridgeIP =${cfg.bridge_ip} 
    ${cfg.extraConfig}
  '';

in {

  ###### interface

  options = {

    virtualisation.hyperd.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables hyperd, a daemon that manages
        virtual machines to run docker containers.
        Users in the "hyperd" group can interact with
        the daemon (e.g. to start or stop VMs) using the
        <command>hyperctl</command> command line tool, among others.
      '';
    };

    virtualisation.hyperd.kernel = mkOption {
      type = types.path;
      default = "/nope";
      description = ''
        TODO
      '';
    };

    virtualisation.hyperd.initrd = mkOption {
      type = types.path;
      default = "/nope";
      description = ''
        TODO
      '';
    };

    virtualisation.hyperd.bridge = mkOption {
      type = types.str;
      default = "hyper0";
      description = ''
        Bridge to be used.
      '';
    };

    virtualisation.hyperd.bridge_ip = mkOption {
      type = types.str;
      default = "192.168.123.0/24";
      description = ''
        IP range of the bridge.
      '';
    };

    virtualisation.hyperd.extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra contents appended to the hyperd configuration file,
        hyperd.conf.
      '';
    };


    virtualisation.hyperd.extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command line arguments passed to hyperd on startup.
      '';
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.hyperd ];

    users.extraGroups.hyperd.gid = config.ids.gids.hyperd;

    systemd.services.hyperd = {
      description = "Hyperd Virtual Machine Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];

      path = [
#          pkgs.bridge-utils
#          pkgs.dmidecode
#          pkgs.dnsmasq
#          pkgs.ebtables
#          pkgs.qemu_kvm
        ];

      preStart = ''
#        rm -f /var/run/hyperd.pid

#        mkdir -p /var/lib/libvirt
#        mkdir -p /var/lib/libvirt/dnsmasq
#
#        chmod 755 /var/lib/libvirt
#        chmod 755 /var/lib/libvirt/dnsmasq

      ''; # */

      serviceConfig = {
        ExecStart = ''
          @${pkgs.hyperd}/bin/hyperd \
          -logtostderr \
          -v=0 \
          -config "${configFile}" \
          ${concatStringsSep " " cfg.extraOptions}'';
        Type = "notify";
        KillMode = "process"; # when stopping, leave the VMs alone
        Restart = "on-failure";
      };
    };

    systemd.sockets.virtlockd = {
      description = "Virtual machine lock manager socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "/run/libvirt/virtlockd-sock" ];
    };

    systemd.services.virtlockd = {
      description = "Virtual machine lock manager";
      serviceConfig.ExecStart = "@${pkgs.libvirt}/sbin/virtlockd virtlockd";
    };
  };
}
