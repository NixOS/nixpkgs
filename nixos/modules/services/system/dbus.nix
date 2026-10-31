# D-Bus configuration and system bus daemon.

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.dbus;

  # The D-Bus files of all registered packages, merged into one directory.
  # This also deduplicates packages that several modules register.
  registeredPackages = pkgs.buildEnv {
    name = "dbus-registered-packages";
    paths = cfg.packages;
    pathsToLink = [
      "/etc/dbus-1"
      "/share/dbus-1"
    ];
  };

  configDir = pkgs.makeDBusConf.override {
    inherit (cfg) apparmor;
    dbus = cfg.dbusPackage;
    suidHelper = "${config.security.wrapperDir}/dbus-daemon-launch-helper";
    serviceDirectories = [ registeredPackages ];
  };

  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    ;

in

{
  options = {

    boot.initrd.systemd.dbus = {
      enable = mkEnableOption "dbus in stage 1" // {
        # TODO: This isn't really necessary, but it avoids a very
        # common red herring error message:
        #
        # $ systemctl ...
        # Failed to connect to system scope bus via local transport: No such file or directory.
        #
        # When systemctl tries and fails to control the system manager
        # over dbus, it fals back to a private bus socket after
        # printing this message. It works, but users often think it is
        # the source of their problem when it isn't.
        default = true;
      };
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

      dbusPackage = lib.mkPackageOption pkgs "dbus" { };

      brokerPackage = lib.mkPackageOption pkgs "dbus-broker" { };

      implementation = mkOption {
        type = types.enum [
          "dbus"
          "broker"
        ];
        default = "broker";
        description = ''
          The implementation to use for the message bus defined by the D-Bus specification.
          Can be either the classic dbus daemon or dbus-broker, which aims to provide high
          performance and reliability, while keeping compatibility to the D-Bus
          reference implementation.
        '';
      };

      packages = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Packages whose D-Bus configuration files are made available to the
          D-Bus system-wide and session-wide message bus. The files in the
          following directories of these packages are merged into one
          directory that the bus configuration reads:
          {file}`«pkg»/etc/dbus-1/system.d`
          {file}`«pkg»/share/dbus-1/system.d`
          {file}`«pkg»/share/dbus-1/system-services`
          {file}`«pkg»/etc/dbus-1/session.d`
          {file}`«pkg»/share/dbus-1/session.d`

          The system bus only reads system services and policies from these
          packages.

          The session services in {file}`«pkg»/share/dbus-1/services` are
          linked into the system profile, without the package's binaries.
          The session bus finds them through {env}`XDG_DATA_DIRS`. Packages
          installed through {option}`environment.systemPackages` or a user
          profile expose their session services without being listed here.
        '';
      };

      apparmor = mkOption {
        type = types.enum [
          "enabled"
          "disabled"
          "required"
        ];
        description = ''
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
      system.switch.inhibitors.dbus-implementation = cfg.implementation;

      environment.etc."dbus-1".source = configDir;

      # The session bus finds services through XDG_DATA_DIRS, so user
      # profiles keep working and registered packages need to be linked in.
      environment.pathsToLink = [ "/share/dbus-1" ];

      users.users.messagebus = {
        uid = config.ids.uids.messagebus;
        description = "D-Bus system message bus daemon user";
        home = "/run/dbus";
        homeMode = "0755";
        group = "messagebus";
      };

      users.groups.messagebus.gid = config.ids.gids.messagebus;

      environment.systemPackages = [
        # Install dbus for dbus tools even when using dbus-broker
        cfg.dbusPackage
        # Expose the session services of registered packages
        registeredPackages
      ];

      # You still need the dbus reference implementation installed to use dbus-broker
      systemd.packages = [
        cfg.dbusPackage
      ];

      services.dbus.packages = [
        cfg.dbusPackage
      ];

      systemd.user.sockets.dbus.wantedBy = [
        "sockets.target"
      ];
    }

    (mkIf config.boot.initrd.systemd.dbus.enable {
      boot.initrd.systemd = {
        users.messagebus = { };
        groups.messagebus = { };
        contents."/etc/dbus-1".source = pkgs.makeDBusConf.override {
          inherit (cfg) apparmor;
          dbus = cfg.dbusPackage;
          suidHelper = "/bin/false";
          serviceDirectories = [
            cfg.dbusPackage
            config.boot.initrd.systemd.package
          ];
        };
        packages = [ cfg.dbusPackage ];
        storePaths = [
          "${cfg.dbusPackage}/bin/dbus-daemon"
          "${config.boot.initrd.systemd.package}/share/dbus-1/system-services"
          "${config.boot.initrd.systemd.package}/share/dbus-1/system.d"
        ];
        targets.sockets.wants = [ "dbus.socket" ];

        # Otherwise, dbus waits on cryptsetup, and systemctl says the
        # bus couldn't be found. This isn't an error (systemctl will
        # fall back to a private bus with PID 1), but it's confusing
        # to unaware users.
        services.dbus.unitConfig.DefaultDependencies = false;
        sockets.dbus.unitConfig.DefaultDependencies = false;
      };
    })

    (mkIf (cfg.implementation == "dbus") {
      security.wrappers.dbus-daemon-launch-helper = {
        source = "${cfg.dbusPackage}/libexec/dbus-daemon-launch-helper";
        owner = "root";
        group = "messagebus";
        setuid = true;
        setgid = false;
        permissions = "u+rx,g+rx,o-rx";
      };

      systemd.services.dbus = {
        aliases = [
          # hack aiding to prevent dbus from restarting when switching from dbus-broker back to dbus
          "dbus-broker.service"
        ];
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
        aliases = [
          # hack aiding to prevent dbus from restarting when switching from dbus-broker back to dbus
          "dbus-broker.service"
        ];
        # Don't restart dbus-daemon. Bad things tend to happen if we do.
        reloadIfChanged = true;
        restartTriggers = [
          configDir
        ];
      };

    })

    (mkIf (cfg.implementation == "broker") {
      environment.systemPackages = [
        cfg.brokerPackage
      ];

      systemd.packages = [
        cfg.brokerPackage
      ];

      # Just to be sure we don't restart through the unit alias
      systemd.services.dbus.reloadIfChanged = true;
      systemd.user.services.dbus.reloadIfChanged = true;

      # NixOS Systemd Module doesn't respect 'Install'
      # https://github.com/NixOS/nixpkgs/issues/108643
      systemd.services.dbus-broker = {
        aliases = [
          # allow other services to just depend on dbus,
          # but also a hack aiding to prevent dbus from restarting when switching from dbus-broker back to dbus
          "dbus.service"
        ];
        unitConfig = {
          # We get errors when reloading the dbus-broker service
          # if /tmp got remounted after this service started
          RequiresMountsFor = [ "/tmp" ];
        };
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
          # allow other services to just depend on dbus,
          # but also a hack aiding to prevent dbus from restarting when switching from dbus-broker back to dbus
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
