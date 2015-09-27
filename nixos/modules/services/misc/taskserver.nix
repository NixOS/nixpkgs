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
        default = "/var/lib/taskserver/data/";
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

    users.users = optional (cfg.user == "taskd") {
      name = "taskd";
      uid = config.ids.uids.taskd;
      description = "Taskserver user";
      group = cfg.group;
    };

    users.groups = optional (cfg.group == "taskd") {
      name = "taskd";
      gid = config.ids.gids.taskd;
    };

    systemd.services.taskserver = {
      description = "taskserver Service.";
      path = [ pkgs.taskserver ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p "${cfg.dataDir}"

        if [[ ! -e "${cfg.dataDir}/.is_initialized" ]]
        then
          ${pkgs.taskserver}/bin/taskd init
          ${pkgs.taskserver}/pki/generate
          for file in {{client,server}.{cert,key},server.crl,ca.cert}
          do
            cp $file.pem "${cfg.dataDir}/"
            ${pkgs.taskserver}/bin/taskd config --force \
              $file "${cfg.dataDir}/$file.pem"
          done

          ${pkgs.taskserver}/bin/taskd config --force server ${cfg.server.host}:${toString cfg.server.port}

          touch "${cfg.dataDir}/.is_initialized"
        else
          # already initialized
          echo "Taskd was initialized. Not initializing again"
        fi
      '';

      environment = {
        TASKDDATA = "${cfg.dataDir}";
      };

      serviceConfig = {
        ExecStart = "${pkgs.taskserver}/bin/taskdctl start";
        ExecStop  = "${pkgs.taskserver}/bin/taskdctl stop";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
