# D-Bus configuration and system bus daemon.

{ config, lib, pkgs, ... }:

let

  cfg = config.services.dbus;

  homeDir = "/run/dbus";

  configDir = pkgs.makeDBusConf {
    inherit (cfg) apparmor;
    suidHelper = "${config.security.wrapperDir}/dbus-daemon-launch-helper";
    serviceDirectories = cfg.packages;
  };

  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;

in

{
  options = {

    boot.initrd.systemd.dbus = {
      enable = mkEnableOption (lib.mdDoc "dbus in stage 1") // { visible = false; };
    };

    services.dbus = {

      enable = mkOption {
        type = types.bool;
        default = false;
        internal = true;
        description = lib.mdDoc ''
          Whether to start the D-Bus message bus daemon, which is
          required by many other system services and applications.
        '';
      };

      implementation = mkOption {
        type = types.enum [ "dbus" "broker" ];
        default = "dbus";
        description = lib.mdDoc ''
          The implementation to use for the message bus defined by the D-Bus specification.
          Can be either the classic dbus daemon or dbus-broker, which aims to provide high
          performance and reliability, while keeping compatibility to the D-Bus
          reference implementation.
        '';

      };

      packages = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = lib.mdDoc ''
          Packages whose D-Bus configuration files should be included in
          the configuration of the D-Bus system-wide or session-wide
          message bus.  Specifically, files in the following directories
          will be included into their respective DBus configuration paths:
          {file}`«pkg»/etc/dbus-1/system.d`
          {file}`«pkg»/share/dbus-1/system.d`
          {file}`«pkg»/share/dbus-1/system-services`
          {file}`«pkg»/etc/dbus-1/session.d`
          {file}`«pkg»/share/dbus-1/session.d`
          {file}`«pkg»/share/dbus-1/services`
        '';
      };

      apparmor = mkOption {
        type = types.enum [ "enabled" "disabled" "required" ];
        description = lib.mdDoc ''
          AppArmor mode for dbus.

          `enabled` enables mediation when it's
          supported in the kernel, `disabled`
          always disables AppArmor even with kernel support, and
          `required` fails when AppArmor was not found
          in the kernel.
        '';
        default = "disabled";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.etc."dbus-1".source = configDir;

      environment.pathsToLink = [
        "/etc/dbus-1"
        "/share/dbus-1"
      ];

      users.users.messagebus = {
        uid = config.ids.uids.messagebus;
        description = "D-Bus system message bus daemon user";
        home = homeDir;
        group = "messagebus";
      };

      users.groups.messagebus.gid = config.ids.gids.messagebus;

      # You still need the dbus reference implementation installed to use dbus-broker
      systemd.packages = [
        pkgs.dbus
      ];

      services.dbus.packages = [
        pkgs.dbus
        config.system.path
      ];

      systemd.user.sockets.dbus.wantedBy = [
        "sockets.target"
      ];
    }

    (mkIf config.boot.initrd.systemd.dbus.enable {
      boot.initrd.systemd = {
        users.messagebus = { };
        groups.messagebus = { };
        contents."/etc/dbus-1".source = pkgs.makeDBusConf {
          inherit (cfg) apparmor;
          suidHelper = "/bin/false";
          serviceDirectories = [ pkgs.dbus ];
        };
        packages = [ pkgs.dbus ];
        storePaths = [ "${pkgs.dbus}/bin/dbus-daemon" ];
        targets.sockets.wants = [ "dbus.socket" ];
      };
    })

    (mkIf (cfg.implementation == "dbus") {
      environment.systemPackages = [
        pkgs.dbus
      ];

      security.wrappers.dbus-daemon-launch-helper = {
        source = "${pkgs.dbus}/libexec/dbus-daemon-launch-helper";
        owner = "root";
        group = "messagebus";
        setuid = true;
        setgid = false;
        permissions = "u+rx,g+rx,o-rx";
      };

      systemd.services.dbus = {
        # Don't restart dbus-daemon. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [
          configDir
        ];
        environment = {
          LD_LIBRARY_PATH = config.system.nssModules.path;
        };
      };

      systemd.user.services.dbus = {
        # Don't restart dbus-daemon. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [
          configDir
        ];
      };

    })

    (mkIf (cfg.implementation == "broker") {
      environment.systemPackages = [
        pkgs.dbus-broker
      ];

      systemd.packages = [
        pkgs.dbus-broker
      ];

      # Just to be sure we don't restart through the unit alias
      systemd.services.dbus.reloadIfChanged = true;
      systemd.user.services.dbus.reloadIfChanged = true;

      # NixOS Systemd Module doesn't respect 'Install'
      # https://github.com/NixOS/nixpkgs/issues/108643
      systemd.services.dbus-broker = {
        aliases = [
          "dbus.service"
        ];
        # Don't restart dbus. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [
          configDir
        ];
        environment = {
          LD_LIBRARY_PATH = config.system.nssModules.path;
        };
      };

      systemd.user.services.dbus-broker = {
        aliases = [
          "dbus.service"
        ];
        # Don't restart dbus. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [
          configDir
        ];
      };
    })

  ]);
}
