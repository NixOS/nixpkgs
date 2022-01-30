{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.power.ups;
in

let
  upsOptions = {name, config, ...}:
  {
    options = {
      # This can be infered from the UPS model by looking at
      # /nix/store/nut/share/driver.list
      driver = mkOption {
        type = types.str;
        description = ''
          Specify the program to run to talk to this UPS.  apcsmart,
          bestups, and sec are some examples.
        '';
      };

      port = mkOption {
        type = types.str;
        description = ''
          The serial port to which your UPS is connected.  /dev/ttyS0 is
          usually the first port on Linux boxes, for example.
        '';
      };

      shutdownOrder = mkOption {
        default = 0;
        type = types.int;
        description = ''
          When you have multiple UPSes on your system, you usually need to
          turn them off in a certain order.  upsdrvctl shuts down all the
          0s, then the 1s, 2s, and so on.  To exclude a UPS from the
          shutdown sequence, set this to -1.
        '';
      };

      maxStartDelay = mkOption {
        default = null;
        type = types.uniq (types.nullOr types.int);
        description = ''
          This can be set as a global variable above your first UPS
          definition and it can also be set in a UPS section.  This value
          controls how long upsdrvctl will wait for the driver to finish
          starting.  This keeps your system from getting stuck due to a
          broken driver or UPS.
        '';
      };

      description = mkOption {
        default = "";
        type = types.str;
        description = ''
          Description of the UPS.
        '';
      };

      directives = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          List of configuration directives for this UPS.
        '';
      };

      summary = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Lines which would be added inside ups.conf for handling this UPS.
        '';
      };

    };

    config = {
      directives = mkOrder 10 ([
        "driver = ${config.driver}"
        "port = ${config.port}"
        ''desc = "${config.description}"''
        "sdorder = ${toString config.shutdownOrder}"
      ] ++ (optional (config.maxStartDelay != null)
            "maxstartdelay = ${toString config.maxStartDelay}")
      );

      summary =
        concatStringsSep "\n      "
          (["[${name}]"] ++ config.directives);
    };
  };

in


{
  options = {
    # powerManagement.powerDownCommands

    power.ups = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Enables support for Power Devices, such as Uninterruptible Power
          Supplies, Power Distribution Units and Solar Controllers.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nut";
        description = "User to run the services as";
      };

      group = mkOption {
        type = types.str;
        default = "nut";
        description = "Group to run the services as";
      };

      # This option is not used yet.
      mode = mkOption {
        default = "standalone";
        type = types.str;
        description = ''
          The MODE determines which part of the NUT is to be started, and
          which configuration files must be modified.

          The values of MODE can be:

          - none: NUT is not configured, or use the Integrated Power
            Management, or use some external system to startup NUT
            components. So nothing is to be started.

          - standalone: This mode address a local only configuration, with 1
            UPS protecting the local system. This implies to start the 3 NUT
            layers (driver, upsd and upsmon) and the matching configuration
            files. This mode can also address UPS redundancy.

          - netserver: same as for the standalone configuration, but also
            need some more ACLs and possibly a specific LISTEN directive in
            upsd.conf.  Since this MODE is opened to the network, a special
            care should be applied to security concerns.

          - netclient: this mode only requires upsmon.
        '';
      };

      schedulerRules = mkOption {
        example = "/etc/nixos/upssched.conf";
        type = types.str;
        description = ''
          File which contains the rules to handle UPS events.
        '';
      };


      maxStartDelay = mkOption {
        default = 45;
        type = types.int;
        description = ''
          This can be set as a global variable above your first UPS
          definition and it can also be set in a UPS section.  This value
          controls how long upsdrvctl will wait for the driver to finish
          starting.  This keeps your system from getting stuck due to a
          broken driver or UPS.
        '';
      };

      upsdConf = mkOption {
        type = types.str;
        default = "${pkgs.nut}/etc/upsd.conf.sample";
        example = "/run/secrets/upsd.conf";
        description = ''
          Path to the <filename>upsd.conf</filename> configuration file.
          For majority of usecases the sample file can be used.

          This file may contain secrets, and should not be in the nix store.
        '';
      };

      upsdUsers = mkOption {
        type = types.str;
        example = "/run/secrets/upsd.users";
        description = ''
          Path to the <filename>upsd.users</filename> configuration file.

          This file often contains secrets, and should not be in the nix store.
        '';
      };

      upsmonConf = mkOption {
        type = types.str;
        example = "/run/secrets/upsmon.conf";
        description = ''
          Path to the <filename>upsmon.conf</filename> configuration file.

          This file often contains secrets, and should not be in the nix store.
        '';
      };

      ups = mkOption {
        default = {};
        # see nut/etc/ups.conf.sample
        description = ''
          This is where you configure all the UPSes that this system will be
          monitoring directly.  These are usually attached to serial ports,
          but USB devices are also supported.
        '';
        type = with types; attrsOf (submodule upsOptions);
      };

    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.nut ];

    systemd.services.ups-init = {
      description = "Uninterruptible Power Supplies configuration updater";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ln -sf ${cfg.upsmonConf} /etc/nut/upsmon.conf
        ln -sf ${cfg.upsdUsers} /etc/nut/upsd.users
        ln -sf ${cfg.upsdConf} /etc/nut/upsd.conf
      '';
    };

    systemd.services.upsmon = {
      description = "Uninterruptible Power Supplies (Monitor)";
      after = [ "network.target" "ups-init.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = cfg.user;
        Group = cfg.group;
      };
      script = "${pkgs.nut}/sbin/upsmon";
      environment.NUT_CONFPATH = "/etc/nut/";
      environment.NUT_STATEPATH = "/var/lib/nut/";
    };

    systemd.services.upsd = {
      description = "Uninterruptible Power Supplies (Daemon)";
      after = [ "network.target" "upsmon.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = cfg.user;
        Group = cfg.group;
      };
      script = "${pkgs.nut}/sbin/upsd -u ${cfg.user}";
      environment.NUT_CONFPATH = "/etc/nut/";
      environment.NUT_STATEPATH = "/var/lib/nut/";
    };

    systemd.services.upsdrv = {
      description = "Uninterruptible Power Supplies (Register all UPS)";
      after = [ "upsd.service" ];
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.nut}/bin/upsdrvctl -u ${cfg.user} start";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = cfg.user;
        Group = cfg.group;
      };
      environment.NUT_CONFPATH = "/etc/nut/";
      environment.NUT_STATEPATH = "/var/lib/nut/";
    };

    environment.etc = {
      "nut/nut.conf".source = pkgs.writeText "nut.conf"
        ''
          MODE = ${cfg.mode}
        '';
      "nut/ups.conf".source = pkgs.writeText "ups.conf"
        ''
          maxstartdelay = ${toString cfg.maxStartDelay}

          ${flip concatStringsSep (forEach (attrValues cfg.ups) (ups: ups.summary)) "

          "}
        '';
      "nut/upssched.conf".source = cfg.schedulerRules;
    };

    power.ups.schedulerRules = mkDefault "${pkgs.nut}/etc/upssched.conf.sample";

    system.activationScripts.upsSetup = stringAfter [ "users" "groups" ]
      ''
        # Used to store pid files of drivers.
        mkdir -p /var/state/ups
        chown ${cfg.user}:${cfg.group} -R /var/state/ups
      '';

    users = {
      users."${cfg.user}" = {
        isSystemUser = true;
        home = "/var/lib/nut/";
        createHome = true;
        group = "nut";
        description = "Network UPS Tools";
      };
      groups."${cfg.group}" = { };
    };

  };
}
