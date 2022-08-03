# D-Bus configuration and system bus daemon.

{ config, lib, options, pkgs, ... }:

with lib;

let

  cfg = config.services.dbus;

  homeDir = "/run/dbus";

  configDir = pkgs.makeDBusConf {
    inherit (cfg) apparmor;
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

      socketActivated = mkOption {
        type = types.nullOr types.bool;
        default = null;
        visible = false;
        description = ''
          Removed option, do not use.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    warnings = optional (cfg.socketActivated != null) (
      let
        files = showFiles options.services.dbus.socketActivated.files;
      in
        "The option 'services.dbus.socketActivated' in ${files} no longer has"
        + " any effect and can be safely removed: the user D-Bus session is"
        + " now always socket activated."
    );

    environment.systemPackages = [ pkgs.dbus.daemon pkgs.dbus ];

    environment.etc."dbus-1".source = configDir;

    users.users.messagebus = {
      uid = config.ids.uids.messagebus;
      description = "D-Bus system message bus daemon user";
      home = homeDir;
      group = "messagebus";
    };

    users.groups.messagebus.gid = config.ids.gids.messagebus;

    systemd.packages = [ pkgs.dbus.daemon ];

    security.wrappers.dbus-daemon-launch-helper = {
      source = "${pkgs.dbus.daemon}/libexec/dbus-daemon-launch-helper";
      owner = "root";
      group = "messagebus";
      setuid = true;
      setgid = false;
      permissions = "u+rx,g+rx,o-rx";
    };

    services.dbus.packages = [
      pkgs.dbus.out
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
      sockets.dbus.wantedBy = [ "sockets.target" ];
    };

    environment.pathsToLink = [ "/etc/dbus-1" "/share/dbus-1" ];
  };
}
