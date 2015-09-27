{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.taskserver;
in {

  options = {
    services.taskserver = {

      enable = mkEnableOption "the Taskwarrior server";

      user = mkOption {
        type = types.str;
        default = "taskd";
        description = "User for Taskserver.";
      };

      group = mkOption {
        type = types.str;
        default = "taskd";
        description = "Group for Taskserver.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/taskserver";
        description = "Data directory for Taskserver.";
      };

      caCert = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Fully qualified path to the CA certificate.";
      };

      ciphers = mkOption {
        type = types.nullOr types.string;
        default = null;
        example = "NORMAL";
        description = ''
          List of GnuTLS ciphers to use. See the GnuTLS documentation for full
          details.
        '';
      };

      confirmation = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Determines whether certain commands are confirmed.
        '';
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Logs debugging information.
        '';
      };

      extensions = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Fully qualified path of the Taskserver extension scripts.
          Currently there are none.
        '';
      };

      ipLog = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Logs the IP addresses of incoming requests.
        '';
      };

      queueSize = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Size of the connection backlog, see <citerefentry>
            <refentrytitle>listen</refentrytitle>
            <manvolnum>2</manvolnum>
          </citerefentry>.
        '';
      };

      requestLimit = mkOption {
        type = types.int;
        default = 1048576;
        description = ''
          Size limit of incoming requests, in bytes.
        '';
      };

      client = {

        allow = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "[Tt]ask [2-9]+" ];
          description = ''
            A list of regular expressions that are matched against the reported
            client id (such as <literal>task 2.3.0</literal>).

            The values <literal>all</literal> or <literal>none</literal> have
            special meaning. Overidden by any entry in the option
            <option>services.taskserver.client.deny</option>.
          '';
        };

        cert = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Fully qualified path of the client cert. This is used by the
            <command>client</command> command.
          '';
        };

        deny = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "[Tt]ask [2-9]+" ];
          description = ''
            A list of regular expressions that are matched against the reported
            client id (such as <literal>task 2.3.0</literal>).

            The values <literal>all</literal> or <literal>none</literal> have
            special meaning. Any entry here overrides these in
            <option>services.taskserver.client.allow</option>.
          '';
        };

      };

      server = {
        host = mkOption {
          type = types.string;
          default = "localhost";
          description = ''
            The address (IPv4, IPv6 or DNS) of the Taskserver.
          '';
        };

        port = mkOption {
          type = types.int;
          default = 53589;
          description = ''
            Port number of the Taskserver.
          '';
        };

        cert = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Fully qualified path to the server certificate";
        };

        crl = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Fully qualified path to the server certificate revocation list.
          '';
        };

        key = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Fully qualified path to the server key.

            Note that reloading the <literal>taskserver.service</literal> causes
            a configuration file reload before the next request is handled.
          '';
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
