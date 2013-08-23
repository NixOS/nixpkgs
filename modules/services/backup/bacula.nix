{ config, pkgs, ... }:

# TODO: test configuration when building nixexpr (use -t parameter)
# TODO: support sqlite3 (it's deprecate?) and mysql

with pkgs.lib;

let
  libDir = "/var/lib/bacula";

  fd_cfg = config.services.bacula-fd;
  fd_conf = pkgs.writeText "bacula-fd.conf"
    ''
      Client {
        Name = "${fd_cfg.name}";
        FDPort = ${toString fd_cfg.port};
        WorkingDirectory = "${libDir}";
        Pid Directory = "/var/run";
        ${fd_cfg.extraClientConfig}
      }
     
      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Director {
        Name = "${name}";
        Password = "${value.password}";
        Monitor = "${value.monitor}";
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
        WorkingDirectory = "${libDir}";
        Pid Directory = "/var/run";
        ${sd_cfg.extraStorageConfig}
      }
 
      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Device {
        Name = "${name}";
        Archive Device = "${value.archiveDevice}";
        Media Type = "${value.mediaType}";
        ${value.extraDeviceConfig}
      }
      '') sd_cfg.device)}

      ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
      Director {
        Name = "${name}";
        Password = "${value.password}";
        Monitor = "${value.monitor}";
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
      Password = "${dir_cfg.password}";
      DirPort = ${toString dir_cfg.port};
      Working Directory = "${libDir}";
      Pid Directory = "/var/run/";
      QueryFile = "${pkgs.bacula}/etc/query.sql";
      ${dir_cfg.extraDirectorConfig}
    }

    Catalog {
      Name = "PostgreSQL";
      dbname = "bacula";
      user = "bacula";
    }

    Messages {
      Name = Standard;
      syslog = all, !skipped, !restored
      ${dir_cfg.extraMessagesConfig}
    }

    ${dir_cfg.extraConfig}
    '';

  # TODO: by default use this config
  bconsole_conf = pkgs.writeText "bconsole.conf"
    ''
    Director {
      Name = ${dir_cfg.name};
      Address = "localhost";
      DirPort = ${toString dir_cfg.port};
      Password = "${dir_cfg.password}";
    }
    '';

  directorOptions = {name, config, ...}:
  {
    options = {
      password = mkOption {
        # TODO: required?
        description = ''
           Specifies the password that must be supplied for a Director to b
        '';
      };
      
      monitor = mkOption {
        default = "no";
        example = "yes";
        description = ''
           If Monitor is set to no (default), this director will have full 
        '';
      };
    };
  };

  deviceOptions = {name, config, ...}:
  {
    options = {
      archiveDevice = mkOption {
        # TODO: required?
        description = ''
          The specified name-string gives the system file name of the storage device managed by this storage daemon. This will usually be the device file name of a removable storage device (tape drive), for example " /dev/nst0" or "/dev/rmt/0mbn". For a DVD-writer, it will be for example /dev/hdc. It may also be a directory name if you are archiving to disk storage.
        '';
      };

      mediaType = mkOption {
        # TODO: required?
        description = ''
          The specified name-string names the type of media supported by this device, for example, "DLT7000". Media type names are arbitrary in that you set them to anything you want, but they must be known to the volume database to keep track of which storage daemons can read which volumes. In general, each different storage type should have a unique Media Type associated with it. The same name-string must appear in the appropriate Storage resource definition in the Director's configuration file.
        '';
      };

      extraDeviceConfig = mkOption {
        default = "";
        description = ''
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
        description = ''
          Whether to enable Bacula File Daemon.
        '';
      };
 
      name = mkOption {
        default = "${config.networking.hostName}-fd";
        description = ''
        	The client name that must be used by the Director when connecting. Generally, it is a good idea to use a name related to the machine so that error messages can be easily identified if you have multiple Clients. This directive is required.
        '';
      };
 
      port = mkOption {
        default = 9102;
        type = types.uniq types.int;
        description = ''
        	This specifies the port number on which the Client listens for Director connections. It must agree with the FDPort specified in the Client resource of the Director's configuration file. The default is 9102.
        '';
      };
 
      director = mkOption {
        default = {};
        description = ''
          This option defines director resources in Bacula File Daemon.
        '';
        type = types.attrsOf types.optionSet;
        options = [ directorOptions ];
      };

      extraClientConfig = mkOption {
        default = "";
        description = ''
          Extra configuration to be passed in Client directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        description = ''
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
        description = ''
          Whether to enable Bacula Storage Daemon.
        '';
      };
 
      name = mkOption {
        default = "${config.networking.hostName}-sd";
        description = ''
          Specifies the Name of the Storage daemon.
        '';
      };
 
      port = mkOption {
        default = 9103;
        type = types.uniq types.int;
        description = ''
          Specifies port number on which the Storage daemon listens for Director connections. The default is 9103.
        '';
      };

      director = mkOption {
        default = {};
        description = ''
          This option defines Director resources in Bacula Storage Daemon.
        '';
        type = types.attrsOf types.optionSet;
        options = [ directorOptions ];
      };

      device = mkOption {
        default = {};
        description = ''
          This option defines Device resources in Bacula Storage Daemon.
        '';
        type = types.attrsOf types.optionSet;
        options = [ deviceOptions ];
      };
 
      extraStorageConfig = mkOption {
        default = "";
        description = ''
          Extra configuration to be passed in Storage directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        description = ''
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
        description = ''
          Whether to enable Bacula Director Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-dir";
        description = ''
          The director name used by the system administrator. This directive is required.
        '';
      };
 
      port = mkOption {
        default = 9101;
        type = types.uniq types.int;
        description = ''
          Specify the port (a positive integer) on which the Director daemon will listen for Bacula Console connections. This same port number must be specified in the Director resource of the Console configuration file. The default is 9101, so normally this directive need not be specified. This directive should not be used if you specify DirAddresses (N.B plural) directive.
        '';
      };
 
      password = mkOption {
        # TODO: required?
        description = ''
           Specifies the password that must be supplied for a Director.
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        description = ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };

      extraDirectorConfig = mkOption {
        default = "";
        description = ''
          Extra configuration to be passed in Director directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraConfig = mkOption {
        default = "";
        description = ''
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
      serviceConfig.ExecStart = "${pkgs.bacula}/sbin/bacula-fd -f -u root -g bacula -c ${fd_conf}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    };

    systemd.services.bacula-sd = mkIf sd_cfg.enable {
      after = [ "network.target" ];
      description = "Bacula Storage Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig.ExecStart = "${pkgs.bacula}/sbin/bacula-sd -f -u bacula -g bacula -c ${sd_conf}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    };

    services.postgresql.enable = dir_cfg.enable == true;

    systemd.services.bacula-dir = mkIf dir_cfg.enable {
      after = [ "network.target" "postgresql.service" ];
      description = "Bacula Director Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig.ExecStart = "${pkgs.bacula}/sbin/bacula-dir -f -u bacula -g bacula -c ${dir_conf}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
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

    users.extraUsers.bacula = {
      group = "bacula";
      uid = config.ids.uids.bacula;
      home = "${libDir}";
      createHome = true;
      description = "Bacula Daemons user";
      shell = "${pkgs.bash}/bin/bash";
    };

    users.extraGroups.bacula.gid = config.ids.gids.bacula;
  };
}
