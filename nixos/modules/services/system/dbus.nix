# D-Bus configuration and system bus daemon.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.dbus;

  homeDir = "/var/run/dbus";

  configDir = pkgs.stdenv.mkDerivation {
    name = "dbus-conf";
    preferLocalBuild = true;
    buildCommand = ''
      ensureDir $out

      cp -v ${pkgs.dbus_daemon}/etc/dbus-1/system.conf $out/system.conf

      # !!! Hm, these `sed' calls are rather error-prone...

      # Tell the daemon where the setuid wrapper around
      # dbus-daemon-launch-helper lives.
      sed -i $out/system.conf \
          -e 's|<servicehelper>.*/libexec/dbus-daemon-launch-helper|<servicehelper>${config.security.wrapperDir}/dbus-daemon-launch-helper|'

      # Add the system-services and system.d directories to the system
      # bus search path.
      sed -i $out/system.conf \
          -e 's|<standard_system_servicedirs/>|${systemServiceDirs}|' \
          -e 's|<includedir>system.d</includedir>|${systemIncludeDirs}|'

      cp ${pkgs.dbus_daemon}/etc/dbus-1/session.conf $out/session.conf

      # Add the services and session.d directories to the session bus
      # search path.
      sed -i $out/session.conf \
          -e 's|<standard_session_servicedirs />|${sessionServiceDirs}&|' \
          -e 's|<includedir>session.d</includedir>|${sessionIncludeDirs}|'
    ''; # */
  };

  systemServiceDirs = concatMapStrings
    (d: "<servicedir>${d}/share/dbus-1/system-services</servicedir> ")
    cfg.packages;

  systemIncludeDirs = concatMapStrings
    (d: "<includedir>${d}/etc/dbus-1/system.d</includedir> ")
    cfg.packages;

  sessionServiceDirs = concatMapStrings
    (d: "<servicedir>${d}/share/dbus-1/services</servicedir> ")
    cfg.packages;

  sessionIncludeDirs = concatMapStrings
    (d: "<includedir>${d}/etc/dbus-1/session.d</includedir> ")
    cfg.packages;

in

{

  ###### interface

  options = {

    services.dbus = {

      enable = mkOption {
        default = true;
        description = ''
          Whether to start the D-Bus message bus daemon, which is
          required by many other system services and applications.
        '';
        merge = pkgs.lib.mergeEnableOption;
      };

      packages = mkOption {
        default = [];
        description = ''
          Packages whose D-Bus configuration files should be included in
          the configuration of the D-Bus system-wide message bus.
          Specifically, every file in
          <filename><replaceable>pkg</replaceable>/etc/dbus-1/system.d</filename>
          is included.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.dbus_daemon pkgs.dbus_tools ];

    environment.etc = singleton
      { source = configDir;
        target = "dbus-1";
      };

    users.extraUsers.messagebus = {
      uid = config.ids.uids.messagebus;
      description = "D-Bus system message bus daemon user";
      home = homeDir;
      group = "messagebus";
    };

    users.extraGroups.messagebus.gid = config.ids.gids.messagebus;

    # FIXME: these are copied verbatim from the dbus source tree.  We
    # should install and use the originals.
    systemd.units."dbus.socket".text =
      ''
        [Unit]
        Description=D-Bus System Message Bus Socket

        [Socket]
        ListenStream=/var/run/dbus/system_bus_socket
      '';

    systemd.units."dbus.service".text =
      ''
        [Unit]
        Description=D-Bus System Message Bus
        Requires=dbus.socket

        [Service]
        ExecStartPre=${pkgs.dbus_tools}/bin/dbus-uuidgen --ensure
        ExecStartPre=-${pkgs.coreutils}/bin/rm -f /var/run/dbus/pid
        ExecStart=${pkgs.dbus_daemon}/bin/dbus-daemon --system --address=systemd: --nofork --systemd-activation
        ExecReload=${pkgs.dbus_tools}/bin/dbus-send --print-reply --system --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig
        OOMScoreAdjust=-900
      '';

    security.setuidOwners = singleton
      { program = "dbus-daemon-launch-helper";
        source = "${pkgs.dbus_daemon}/libexec/dbus-daemon-launch-helper";
        owner = "root";
        group = "messagebus";
        setuid = true;
        setgid = false;
        permissions = "u+rx,g+rx,o-rx";
      };

    services.dbus.packages =
      [ "/nix/var/nix/profiles/default"
        config.system.path
      ];

    environment.pathsToLink = [ "/etc/dbus-1" "/share/dbus-1" ];

  };

}
