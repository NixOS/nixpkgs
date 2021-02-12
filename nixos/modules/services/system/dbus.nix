# D-Bus configuration and system bus daemon.

{ config, lib, options, pkgs, ... }:

with lib;

let

  cfg = config.services.dbus;

  brokerCfg = config.services.dbus-broker;

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

    services.dbus-broker.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable dbus-broker, implementation of a message bus
        as defined by the D-Bus specification. Its aim is to provide high
        performance and reliability, while keeping compatibility to the D-Bus
        reference implementation. You must disable services.dbus.enable to use this.
      '';
    };

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
        description = ''
          Packages whose D-Bus configuration files should be included in
          the configuration of the D-Bus system-wide or session-wide
          message bus.  Specifically, files in the following directories
          will be included into their respective DBus configuration paths:
          <filename><replaceable>pkg</replaceable>/etc/dbus-1/system.d</filename>
          <filename><replaceable>pkg</replaceable>/share/dbus-1/system.d</filename>
          <filename><replaceable>pkg</replaceable>/share/dbus-1/system-services</filename>
          <filename><replaceable>pkg</replaceable>/etc/dbus-1/session.d</filename>
          <filename><replaceable>pkg</replaceable>/share/dbus-1/session.d</filename>
          <filename><replaceable>pkg</replaceable>/share/dbus-1/services</filename>
        '';
      };

      apparmor = mkOption {
        type = types.enum [ "enabled" "disabled" "required" ];
        description = ''
          AppArmor mode for dbus.

          <literal>enabled</literal> enables mediation when it's
          supported in the kernel, <literal>disabled</literal>
          always disables AppArmor even with kernel support, and
          <literal>required</literal> fails when AppArmor was not found
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

  config = mkMerge [
    # You still need the dbus reference implementation installed to use dbus-broker
    (mkIf (cfg.enable || brokerCfg.enable) {
      warnings = optional (cfg.socketActivated != null) (
        let
          files = showFiles options.services.dbus.socketActivated.files;
        in
          "The option 'services.dbus.socketActivated' in ${files} no longer has"
          + " any effect and can be safely removed: the user D-Bus session is"
          + " now always socket activated."
      );

      assertions = [
        { assertion = brokerCfg.enable -> !cfg.enable;
          message = ''
            You cannot use services.dbus.enable with services.dbus-broker.enable. Please disable DBus.
          '';
        }
      ];

      environment.etc."dbus-1".source = configDir;

      users.users.messagebus = {
        uid = config.ids.uids.messagebus;
        description = "D-Bus system message bus daemon user";
        home = homeDir;
        group = "messagebus";
      };

      users.groups.messagebus.gid = config.ids.gids.messagebus;

      systemd.packages = [
        pkgs.dbus.daemon
      ];

      services.dbus.packages = [
        pkgs.dbus.out
        config.system.path
      ];

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

      systemd.user = {
        services.dbus = {
          # Don't restart dbus-daemon. Bad things tend to happen if we do.
          reloadIfChanged = true;
          restartTriggers = [
            configDir
          ];
        };
        sockets.dbus.wantedBy = [
          "sockets.target"
        ];
      };

      environment.pathsToLink = [
        "/etc/dbus-1"
        "/share/dbus-1"
      ];
    })

    (mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.dbus
        pkgs.dbus.daemon
      ];

      security.wrappers.dbus-daemon-launch-helper = {
        source = "${pkgs.dbus.daemon}/libexec/dbus-daemon-launch-helper";
        owner = "root";
        group = "messagebus";
        setuid = true;
        setgid = false;
        permissions = "u+rx,g+rx,o-rx";
      };
    })

    (mkIf brokerCfg.enable {
      environment.systemPackages = [
        pkgs.dbus-broker
      ];

      systemd.packages = [
        pkgs.dbus-broker
      ];

      # NixOS Systemd Module doesn't respect 'Install'
      # https://github.com/NixOS/nixpkgs/issues/108643
      systemd.services.dbus-broker.aliases = [
        "dbus.service"
      ];

      systemd.user.services.dbus-broker.aliases = [
        "dbus.service"
      ];
    })

  ];
}
