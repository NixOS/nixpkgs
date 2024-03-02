{ config, lib, pkgs, ... }:


# TODO: test configuration when building nixexpr (use -t parameter)
# TODO: support sqlite3 (it's deprecate?) and mysql

with lib;

let
  libDir = "/var/lib/bacula";

  fd_cfg = config.services.bacula-fd;
  fd_conf = pkgs.writeText "bacula-fd.conf"
    ''
      Client {
        Name = "${fd_cfg.name}";
        FDPort = ${toString fd_cfg.port};
        WorkingDirectory = ${libDir};
        Pid Directory = /run;
        ${fd_cfg.extraClientConfig}
      }

      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Director {
        Name = "${name}";
        Password = ${value.password};
        Monitor = ${value.monitor};
      }
      '') fd_cfg.director)}

      Messages {
        Name = Standard;
        syslog = all, !skipped, !restored
        ${fd_cfg.extraMessagesConfig}
      }
    '';

  sd_cfg = config.services.bacula-sd;
  sd_conf = pkgs.writeText "bacula-sd.conf"
    ''
      Storage {
        Name = "${sd_cfg.name}";
        SDPort = ${toString sd_cfg.port};
        WorkingDirectory = ${libDir};
        Pid Directory = /run;
        ${sd_cfg.extraStorageConfig}
      }

      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Autochanger {
        Name = "${name}";
        Device = ${concatStringsSep ", " (map (a: "\"${a}\"") value.devices)};
        Changer Device =  ${value.changerDevice};
        Changer Command = ${value.changerCommand};
        ${value.extraAutochangerConfig}
      }
      '') sd_cfg.autochanger)}

      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Device {
        Name = "${name}";
        Archive Device = ${value.archiveDevice};
        Media Type = ${value.mediaType};
        ${value.extraDeviceConfig}
      }
      '') sd_cfg.device)}

      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Director {
        Name = "${name}";
        Password = ${value.password};
        Monitor = ${value.monitor};
      }
      '') sd_cfg.director)}

      Messages {
        Name = Standard;
        syslog = all, !skipped, !restored
        ${sd_cfg.extraMessagesConfig}
      }
    '';

  dir_cfg = config.services.bacula-dir;
  dir_conf = pkgs.writeText "bacula-dir.conf"
    ''
    Director {
      Name = "${dir_cfg.name}";
      Password = ${dir_cfg.password};
      DirPort = ${toString dir_cfg.port};
      Working Directory = ${libDir};
      Pid Directory = /run/;
      QueryFile = ${pkgs.bacula}/etc/query.sql;
      ${dir_cfg.extraDirectorConfig}
    }

    Catalog {
      Name = PostgreSQL;
      dbname = bacula;
      user = bacula;
    }

    Messages {
      Name = Standard;
      syslog = all, !skipped, !restored
      ${dir_cfg.extraMessagesConfig}
    }

    ${dir_cfg.extraConfig}
    '';

  directorOptions = {...}:
  {
    options = {
      password = mkOption {
        type = types.str;
        # TODO: required?
        description = lib.mdDoc ''
          Specifies the password that must be supplied for the default Bacula
          Console to be authorized. The same password must appear in the
          Director resource of the Console configuration file. For added
          security, the password is never passed across the network but instead
          a challenge response hash code created with the password. This
          directive is required. If you have either /dev/random or bc on your
          machine, Bacula will generate a random password during the
          configuration process, otherwise it will be left blank and you must
          manually supply it.

          The password is plain text. It is not generated through any special
          process but as noted above, it is better to use random text for
          security reasons.
        '';
      };

      monitor = mkOption {
        type = types.enum [ "no" "yes" ];
        default = "no";
        example = "yes";
        description = lib.mdDoc ''
          If Monitor is set to `no`, this director will have
          full access to this Storage daemon. If Monitor is set to
          `yes`, this director will only be able to fetch the
          current status of this Storage daemon.

          Please note that if this director is being used by a Monitor, we
          highly recommend to set this directive to yes to avoid serious
          security problems.
        '';
      };
    };
  };

  autochangerOptions = {...}:
  {
    options = {
      changerDevice = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The specified name-string must be the generic SCSI device name of the
          autochanger that corresponds to the normal read/write Archive Device
          specified in the Device resource. This generic SCSI device name
          should be specified if you have an autochanger or if you have a
          standard tape drive and want to use the Alert Command (see below).
          For example, on Linux systems, for an Archive Device name of
          `/dev/nst0`, you would specify
          `/dev/sg0` for the Changer Device name.  Depending
          on your exact configuration, and the number of autochangers or the
          type of autochanger, what you specify here can vary. This directive
          is optional. See the Using AutochangersAutochangersChapter chapter of
          this manual for more details of using this and the following
          autochanger directives.
          '';
      };

      changerCommand = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The name-string specifies an external program to be called that will
          automatically change volumes as required by Bacula. Normally, this
          directive will be specified only in the AutoChanger resource, which
          is then used for all devices. However, you may also specify the
          different Changer Command in each Device resource. Most frequently,
          you will specify the Bacula supplied mtx-changer script as follows:

          `"/path/mtx-changer %c %o %S %a %d"`

          and you will install the mtx on your system (found in the depkgs
          release). An example of this command is in the default bacula-sd.conf
          file. For more details on the substitution characters that may be
          specified to configure your autochanger please see the
          AutochangersAutochangersChapter chapter of this manual. For FreeBSD
          users, you might want to see one of the several chio scripts in
          examples/autochangers.
          '';
        default = "/etc/bacula/mtx-changer %c %o %S %a %d";
      };

      devices = mkOption {
        description = lib.mdDoc "";
        type = types.listOf types.str;
      };

      extraAutochangerConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Autochanger directive.
        '';
        example = ''

        '';
      };
    };
  };


  deviceOptions = {...}:
  {
    options = {
      archiveDevice = mkOption {
        # TODO: required?
        type = types.str;
        description = lib.mdDoc ''
          The specified name-string gives the system file name of the storage
          device managed by this storage daemon. This will usually be the
          device file name of a removable storage device (tape drive), for
          example `/dev/nst0` or
          `/dev/rmt/0mbn`. For a DVD-writer, it will be for
          example `/dev/hdc`. It may also be a directory name
          if you are archiving to disk storage. In this case, you must supply
          the full absolute path to the directory. When specifying a tape
          device, it is preferable that the "non-rewind" variant of the device
          file name be given.
        '';
      };

      mediaType = mkOption {
        # TODO: required?
        type = types.str;
        description = lib.mdDoc ''
          The specified name-string names the type of media supported by this
          device, for example, `DLT7000`. Media type names are
          arbitrary in that you set them to anything you want, but they must be
          known to the volume database to keep track of which storage daemons
          can read which volumes. In general, each different storage type
          should have a unique Media Type associated with it. The same
          name-string must appear in the appropriate Storage resource
          definition in the Director's configuration file.

          Even though the names you assign are arbitrary (i.e. you choose the
          name you want), you should take care in specifying them because the
          Media Type is used to determine which storage device Bacula will
          select during restore. Thus you should probably use the same Media
          Type specification for all drives where the Media can be freely
          interchanged. This is not generally an issue if you have a single
          Storage daemon, but it is with multiple Storage daemons, especially
          if they have incompatible media.

          For example, if you specify a Media Type of `DDS-4`
          then during the restore, Bacula will be able to choose any Storage
          Daemon that handles `DDS-4`. If you have an
          autochanger, you might want to name the Media Type in a way that is
          unique to the autochanger, unless you wish to possibly use the
          Volumes in other drives. You should also ensure to have unique Media
          Type names if the Media is not compatible between drives. This
          specification is required for all devices.

          In addition, if you are using disk storage, each Device resource will
          generally have a different mount point or directory. In order for
          Bacula to select the correct Device resource, each one must have a
          unique Media Type.
        '';
      };

      extraDeviceConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Device directive.
        '';
        example = ''
          LabelMedia = yes
          Random Access = no
          AutomaticMount = no
          RemovableMedia = no
          MaximumOpenWait = 60
          AlwaysOpen = no
        '';
      };
    };
  };

in {
  options = {
    services.bacula-fd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the Bacula File Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-fd";
        defaultText = literalExpression ''"''${config.networking.hostName}-fd"'';
        type = types.str;
        description = lib.mdDoc ''
          The client name that must be used by the Director when connecting.
          Generally, it is a good idea to use a name related to the machine so
          that error messages can be easily identified if you have multiple
          Clients. This directive is required.
        '';
      };

      port = mkOption {
        default = 9102;
        type = types.port;
        description = lib.mdDoc ''
          This specifies the port number on which the Client listens for
          Director connections. It must agree with the FDPort specified in
          the Client resource of the Director's configuration file.
        '';
      };

      director = mkOption {
        default = {};
        description = lib.mdDoc ''
          This option defines director resources in Bacula File Daemon.
        '';
        type = with types; attrsOf (submodule directorOptions);
      };

      extraClientConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Client directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };
    };

    services.bacula-sd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable Bacula Storage Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-sd";
        defaultText = literalExpression ''"''${config.networking.hostName}-sd"'';
        type = types.str;
        description = lib.mdDoc ''
          Specifies the Name of the Storage daemon.
        '';
      };

      port = mkOption {
        default = 9103;
        type = types.port;
        description = lib.mdDoc ''
          Specifies port number on which the Storage daemon listens for
          Director connections.
        '';
      };

      director = mkOption {
        default = {};
        description = lib.mdDoc ''
          This option defines Director resources in Bacula Storage Daemon.
        '';
        type = with types; attrsOf (submodule directorOptions);
      };

      device = mkOption {
        default = {};
        description = lib.mdDoc ''
          This option defines Device resources in Bacula Storage Daemon.
        '';
        type = with types; attrsOf (submodule deviceOptions);
      };

      autochanger = mkOption {
        default = {};
        description = lib.mdDoc ''
          This option defines Autochanger resources in Bacula Storage Daemon.
        '';
        type = with types; attrsOf (submodule autochangerOptions);
      };

      extraStorageConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Storage directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };

    };

    services.bacula-dir = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable Bacula Director Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-dir";
        defaultText = literalExpression ''"''${config.networking.hostName}-dir"'';
        type = types.str;
        description = lib.mdDoc ''
          The director name used by the system administrator. This directive is
          required.
        '';
      };

      port = mkOption {
        default = 9101;
        type = types.port;
        description = lib.mdDoc ''
          Specify the port (a positive integer) on which the Director daemon
          will listen for Bacula Console connections. This same port number
          must be specified in the Director resource of the Console
          configuration file. The default is 9101, so normally this directive
          need not be specified. This directive should not be used if you
          specify DirAddresses (N.B plural) directive.
        '';
      };

      password = mkOption {
        # TODO: required?
        type = types.str;
        description = lib.mdDoc ''
           Specifies the password that must be supplied for a Director.
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };

      extraDirectorConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration to be passed in Director directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Extra configuration for Bacula Director Daemon.
        '';
        example = ''
          TODO
        '';
      };
    };
  };

  config = mkIf (fd_cfg.enable || sd_cfg.enable || dir_cfg.enable) {
    systemd.services.bacula-fd = mkIf fd_cfg.enable {
      after = [ "network.target" ];
      description = "Bacula File Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig = {
        ExecStart = "${pkgs.bacula}/sbin/bacula-fd -f -u root -g bacula -c ${fd_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LogsDirectory = "bacula";
        StateDirectory = "bacula";
      };
    };

    systemd.services.bacula-sd = mkIf sd_cfg.enable {
      after = [ "network.target" ];
      description = "Bacula Storage Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig = {
        ExecStart = "${pkgs.bacula}/sbin/bacula-sd -f -u bacula -g bacula -c ${sd_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LogsDirectory = "bacula";
        StateDirectory = "bacula";
      };
    };

    services.postgresql.enable = lib.mkIf dir_cfg.enable true;

    systemd.services.bacula-dir = mkIf dir_cfg.enable {
      after = [ "network.target" "postgresql.service" ];
      description = "Bacula Director Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig = {
        ExecStart = "${pkgs.bacula}/sbin/bacula-dir -f -u bacula -g bacula -c ${dir_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LogsDirectory = "bacula";
        StateDirectory = "bacula";
      };
      preStart = ''
        if ! test -e "${libDir}/db-created"; then
            ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole bacula
            #${pkgs.postgresql}/bin/createdb --owner bacula bacula

            # populate DB
            ${pkgs.bacula}/etc/create_bacula_database postgresql
            ${pkgs.bacula}/etc/make_bacula_tables postgresql
            ${pkgs.bacula}/etc/grant_bacula_privileges postgresql
            touch "${libDir}/db-created"
        else
            ${pkgs.bacula}/etc/update_bacula_tables postgresql || true
        fi
      '';
    };

    environment.systemPackages = [ pkgs.bacula ];

    users.users.bacula = {
      group = "bacula";
      uid = config.ids.uids.bacula;
      home = "${libDir}";
      createHome = true;
      description = "Bacula Daemons user";
      shell = "${pkgs.bash}/bin/bash";
    };

    users.groups.bacula.gid = config.ids.gids.bacula;
  };
}
