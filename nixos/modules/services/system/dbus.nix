# D-Bus configuration and system bus daemon.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.dbus;

  homeDir = "/run/dbus";

  systemExtraxml = concatStrings (flip concatMap cfg.packages (d: [
    "<servicedir>${d}/share/dbus-1/system-services</servicedir>"
    "<includedir>${d}/etc/dbus-1/system.d</includedir>"
  ]));

  sessionExtraxml = concatStrings (flip concatMap cfg.packages (d: [
    "<servicedir>${d}/share/dbus-1/services</servicedir>"
    "<includedir>${d}/etc/dbus-1/session.d</includedir>"
  ]));

  daemonArgs = "--address=systemd: --nofork --nopidfile --systemd-activation";

  configDir = pkgs.stdenv.mkDerivation {
    name = "dbus-conf";

    preferLocalBuild = true;
    allowSubstitutes = false;

    buildCommand = ''
      mkdir -p $out

      cp ${pkgs.dbus.out}/share/dbus-1/{system,session}.conf $out

      # avoid circular includes
      sed -ri 's@(<include ignore_missing="yes">/etc/dbus-1/(system|session)\.conf</include>)@<!-- \1 -->@g' $out/{system,session}.conf

      # include by full path
      sed -ri "s@/etc/dbus-1/(system|session)-@$out/\1-@" $out/{system,session}.conf

      sed '${./dbus-system-local.conf.in}' \
        -e 's,@servicehelper@,${config.security.wrapperDir}/dbus-daemon-launch-helper,g' \
        -e 's,@extra@,${systemExtraxml},' \
        > "$out/system-local.conf"

      sed '${./dbus-session-local.conf.in}' \
        -e 's,@extra@,${sessionExtraxml},' \
        > "$out/session-local.conf"
    '';
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

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.dbus.daemon pkgs.dbus ];

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

    systemd.packages = [ pkgs.dbus.daemon ];

    security.setuidOwners = singleton
      { program = "dbus-daemon-launch-helper";
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
      serviceConfig.ExecStart = [
        ""
        "${lib.getBin pkgs.dbus}/bin/dbus-daemon --config-file=${configDir}/system.conf ${daemonArgs}"
      ];
    };

    systemd.user = {
      services.dbus = {
        # Don't restart dbus-daemon. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [ configDir ];
        serviceConfig.ExecStart = [
          ""
          "${lib.getBin pkgs.dbus}/bin/dbus-daemon --config-file=${configDir}/session.conf ${daemonArgs}"
        ];
      };
      sockets.dbus.wantedBy = mkIf cfg.socketActivated [ "sockets.target" ];
    };

    environment.pathsToLink = [ "/etc/dbus-1" "/share/dbus-1" ];
  };
}
