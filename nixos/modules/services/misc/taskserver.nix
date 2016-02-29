{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.taskserver;
in {

  options = {
    services.taskserver = {

      enable = mkEnableOption "Taskwarrior server.";

      user = mkOption {
        default = "taskd";
        description = "User for taskserver.";
      };

      group = mkOption {
        default = "taskd";
        description = "Group for taskserver.";
      };

      dataDir = mkOption {
        default = "/var/lib/taskserver/";
        description = "Data directory for taskserver.";
        type = types.path;
      };

      caCert = mkOption {
        description = "Fully qualified path to the CA certificate. Optional.";
        type = types.path;
      };

      ciphers = mkOption {
        default = "NORMAL";
        description = ''
          List of GnuTLS ciphers to use. See your
          GnuTLS documentation for full details.
        '';
        type = types.string;
      };

      confirmation = mkOption {
        default = true;
        description = ''
          Determines whether certain commands are confirmed.
        '';
        type = types.bool;
      };

      client = {

        allow = mkOption {
          default = [ "[Tt]ask [2-9]+" ];
          description = ''
             A comma-separated list of regular expressions that are matched
             against the reported client id (such as "task 2.3.0").  The values
             'all' or 'none' have special meaning. Overidden by any
             'client.deny' entry.
          '';
          type = types.listOf types.str;
        };

        cert = mkOption {
          description = ''
             Fully qualified path of the client cert.  This is used by the
             'client' command.
          '';
          type = types.path;
        };

        deny = mkOption {
          default = [ "[Tt]ask [2-9]+" ];
          description = ''
            A comma-separated list of regular expressions that are matched
            against the reported client id (such as "task 2.3.0"). The values
            'all' or 'none' have special meaning.  Any 'client.deny' entry
            overrides any 'client.allow' entry.
          '';
          type = types.listOf types.str;
        };

      };

      debug = mkOption {
        default = false;
        description = ''
          Logs debugging information.
        '';
        type = types.bool;
      };

      extensions = mkOption {
        description = ''
          Fully qualified path of the Taskserver extension scripts.  Currently
          there are none.
        '';
        type = types.path;
      };

      ipLog = mkOption {
        default = true;
        description = ''
          Logs the IP addresses of incoming requests.
        '';
        type = types.bool;
      };

      log = mkOption {
        default = /tmp/taskd.log;
        description = ''
          Fully-qualified path name to the Taskserver log file.
        '';
        type = types.path;
      };

      pidFile = mkOption {
        default = /tmp/taskd.pid;
        description = ''
          Fully-qualified path name to the Taskserver PID file. This is used
          by the 'taskdctl' script to start/stop the daemon.
        '';
        type = types.path;
      };

      queueSize = mkOption {
        default = 10;
        description = ''
          Size of the connection backlog.  See 'man listen'.
        '';
        type = types.int;
      };

      requestLimit = mkOption {
        default = 1048576;
        description = ''
          Size limit of incoming requests, in bytes.
        '';
        type = types.int;
      };

      server = {
        host = mkOption {
          default = "localhost";
          description = ''
            The address (IPv4, IPv6 or DNS) of the Taskserver.
          '';
          type = types.string;
        };

        port = mkOption {
          default = 53589;
          description = ''
            Portnumber of the Taskserver.
          '';
          type = types.int;
        };

        cert = mkOption {
          description = "Fully qualified path to the server certificate";
          type = types.path;
        };

        crl = mkOption {
          description = ''
            Fully qualified path to the server certificate
            revocation list.
          '';
          type = types.path;
        };

        key = mkOption {
          description = ''
            Fully qualified path to the server key.

            Note that sending the HUP signal to the Taskserver
            causes a configuration file reload before the next
            request is handled.
          '';
          type = types.path;
        };
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.taskserver ];

    users.extraUsers = singleton
      { name = cfg.user;
        group = cfg.group;
        createHome = true;
        home = cfg.dataDir;
        uid = config.ids.uids.taskserver;
      };

    users.extraGroups = singleton
      { name = cfg.group;
        gid = config.ids.gids.taskserver;
      };

    systemd.services.taskserver = {
      description = "taskserver Service.";
      path = [ pkgs.taskserver ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = { TASKDDATA = "${cfg.dataDir}"; };

      serviceConfig = {
        ExecStart = "${pkgs.taskserver}/bin/taskdctl start";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
