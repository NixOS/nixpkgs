# D-Bus configuration and system bus daemon.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.dbus;

  homeDir = "/run/dbus";

  configDir = pkgs.makeDBusConf {
    suidHelper = "${config.security.wrapperDir}/dbus-daemon-launch-helper";
    serviceDirectories = cfg.packages;
  };

in

{

  ###### interface

  options = {

    services.dbus = {

      enable = mkOption {
        type = types.bool;
        default = false;
        internal = true;
        description = ''
          Whether to start the D-Bus message bus daemon, which is
          required by many other system services and applications.
        '';
      };

      forceSystemd = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If NixOS is using another init system, then D-Bus will be
          built without systemd support. Set this to true if you want
          to include it anyway.
        '';
      };

      package = mkOption {
        type = types.bool;
        default = pkgs.dbus;
        defaultText = "pkgs.dbus";
        description = ''
          Which D-Bus package to use
        '';
      };

      packages = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Packages whose D-Bus configuration files should be included in
          the configuration of the D-Bus system-wide or session-wide
          message bus.  Specifically, files in the following directories
          will be included into their respective DBus configuration paths:
          <filename><replaceable>pkg</replaceable>/etc/dbus-1/system.d</filename>
          <filename><replaceable>pkg</replaceable>/share/dbus-1/system-services</filename>
          <filename><replaceable>pkg</replaceable>/etc/dbus-1/session.d</filename>
          <filename><replaceable>pkg</replaceable>/share/dbus-1/services</filename>
        '';
      };

      socketActivated = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Make the user instance socket activated.
        '';
      };
    };
  };

  ###### implementation

  config = let dbus = config.services.dbus.package;
  in mkIf cfg.enable {

    environment.systemPackages = [ dbus.daemon dbus ];

    environment.etc = singleton
      { source = configDir;
        target = "dbus-1";
      };

    users.users.messagebus = {
      uid = config.ids.uids.messagebus;
      description = "D-Bus system message bus daemon user";
      home = homeDir;
      group = "messagebus";
    };

    users.groups.messagebus.gid = config.ids.gids.messagebus;

    systemd.packages = [ dbus.daemon ];

    security.wrappers.dbus-daemon-launch-helper = {
      source = "${dbus.daemon}/libexec/dbus-daemon-launch-helper";
      owner = "root";
      group = "messagebus";
      setuid = true;
      setgid = false;
      permissions = "u+rx,g+rx,o-rx";
    };

    services.dbus.package =
      if config.systemd.enable || config.services.dbus.forceSystemd
      then pkgs.dbus
      else pkgs.dbus.override { systemdSupport = false; };

    services.dbus.packages = [
      dbus.out
      config.system.path
    ];

    systemd.services.dbus = {
      # Don't restart dbus-daemon. Bad things tend to happen if we do.
      reloadIfChanged = true;
      restartTriggers = [ configDir ];
      environment = { LD_LIBRARY_PATH = config.system.nssModules.path; };
    };

    systemd.user = {
      services.dbus = {
        # Don't restart dbus-daemon. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [ configDir ];
      };
      sockets.dbus.wantedBy = mkIf cfg.socketActivated [ "sockets.target" ];
    };

    environment.pathsToLink = [ "/etc/dbus-1" "/share/dbus-1" ];
  };
}
