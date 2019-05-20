{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.mosquitto;

  listenerConf = optionalString cfg.ssl.enable ''
    listener ${toString cfg.ssl.port} ${cfg.ssl.host}
    cafile ${cfg.ssl.cafile}
    certfile ${cfg.ssl.certfile}
    keyfile ${cfg.ssl.keyfile}
  '';

  passwordConf = optionalString cfg.checkPasswords ''
    password_file ${cfg.dataDir}/passwd
  '';

  mosquittoConf = pkgs.writeText "mosquitto.conf" ''
    acl_file ${aclFile}
    persistence true
    allow_anonymous ${boolToString cfg.allowAnonymous}
    bind_address ${cfg.host}
    port ${toString cfg.port}
    ${passwordConf}
    ${listenerConf}
    ${cfg.extraConf}
  '';

  userAcl = (concatStringsSep "\n\n" (mapAttrsToList (n: c:
    "user ${n}\n" + (concatStringsSep "\n" c.acl)) cfg.users
  ));

  aclFile = pkgs.writeText "mosquitto.acl" ''
    ${cfg.aclExtraConf}
    ${userAcl}
  '';

in

{

  ###### Interface

  options = {
    services.mosquitto = {
      enable = mkEnableOption "the MQTT Mosquitto broker";

      host = mkOption {
        default = "127.0.0.1";
        example = "0.0.0.0";
        type = types.string;
        description = ''
          Host to listen on without SSL.
        '';
      };

      port = mkOption {
        default = 1883;
        example = 1883;
        type = types.int;
        description = ''
          Port on which to listen without SSL.
        '';
      };

      ssl = {
        enable = mkEnableOption "SSL listener";

        cafile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Path to PEM encoded CA certificates.";
        };

        certfile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Path to PEM encoded server certificate.";
        };

        keyfile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Path to PEM encoded server key.";
        };

        host = mkOption {
          default = "0.0.0.0";
          example = "localhost";
          type = types.string;
          description = ''
            Host to listen on with SSL.
          '';
        };

        port = mkOption {
          default = 8883;
          example = 8883;
          type = types.int;
          description = ''
            Port on which to listen with SSL.
          '';
        };
      };

      dataDir = mkOption {
        default = "/var/lib/mosquitto";
        type = types.path;
        description = ''
          The data directory.
        '';
      };

      users = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            password = mkOption {
              type = with types; uniq (nullOr str);
              default = null;
              description = ''
                Specifies the (clear text) password for the MQTT User.
              '';
            };

            hashedPassword = mkOption {
              type = with types; uniq (nullOr str);
              default = null;
              description = ''
                Specifies the hashed password for the MQTT User.
                <option>hashedPassword</option> overrides <option>password</option>.
                To generate hashed password install <literal>mosquitto</literal>
                package and use <literal>mosquitto_passwd</literal>.
              '';
            };

            acl = mkOption {
              type = types.listOf types.string;
              example = [ "topic read A/B" "topic A/#" ];
              description = ''
                Control client access to topics on the broker.
              '';
            };
          };
        });
        example = { john = { password = "123456"; acl = [ "topic readwrite john/#" ]; }; };
        description = ''
          A set of users and their passwords and ACLs.
        '';
      };

      allowAnonymous = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Allow clients to connect without authentication.
        '';
      };

      checkPasswords = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = ''
          Refuse connection when clients provide incorrect passwords.
        '';
      };

      extraConf = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra config to append to `mosquitto.conf` file.
        '';
      };

      aclExtraConf = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra config to prepend to the ACL file.
        '';
      };

    };
  };


  ###### Implementation

  config = mkIf cfg.enable {

    systemd.services.mosquitto = {
      description = "Mosquitto MQTT Broker Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "main";
        User = "mosquitto";
        Group = "mosquitto";
        RuntimeDirectory = "mosquitto";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        ExecStart = "${pkgs.mosquitto}/bin/mosquitto -c ${mosquittoConf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
      preStart = ''
        rm -f ${cfg.dataDir}/passwd
        touch ${cfg.dataDir}/passwd
      '' + concatStringsSep "\n" (
        mapAttrsToList (n: c:
          if c.hashedPassword != null then
            "echo '${n}:${c.hashedPassword}' >> ${cfg.dataDir}/passwd"
          else optionalString (c.password != null)
            "${pkgs.mosquitto}/bin/mosquitto_passwd -b ${cfg.dataDir}/passwd ${n} '${c.password}'"
        ) cfg.users);
    };

    users.users.mosquitto = {
      description = "Mosquitto MQTT Broker Daemon owner";
      group = "mosquitto";
      uid = config.ids.uids.mosquitto;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.mosquitto.gid = config.ids.gids.mosquitto;

  };
}
