{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.parsedmarc;
  opt = options.services.parsedmarc;
  isSecret = v: isAttrs v && v ? _secret && isString v._secret;
  ini = pkgs.formats.ini {
    mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
      mkValueString =
        v:
        if isInt v then
          toString v
        else if isString v then
          v
        else if true == v then
          "True"
        else if false == v then
          "False"
        else if isSecret v then
          hashString "sha256" v._secret
        else
          throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty { }) v}";
    };
  };
  inherit (builtins)
    elem
    isAttrs
    isString
    isInt
    isList
    typeOf
    hashString
    ;
in
{
  options.services.parsedmarc = {

    enable = lib.mkEnableOption ''
      parsedmarc, a DMARC report monitoring service
    '';

    provision = {
      localMail = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether Postfix and Dovecot should be set up to receive
            mail locally. parsedmarc will be configured to watch the
            local inbox as the automatically created user specified in
            [](#opt-services.parsedmarc.provision.localMail.recipientName)
          '';
        };

        recipientName = lib.mkOption {
          type = lib.types.str;
          default = "dmarc";
          description = ''
            The DMARC mail recipient name, i.e. the name part of the
            email address which receives DMARC reports.

            A local user with this name will be set up and assigned a
            randomized password on service start.
          '';
        };

        hostname = lib.mkOption {
          type = lib.types.str;
          default = config.networking.fqdn;
          defaultText = lib.literalExpression "config.networking.fqdn";
          example = "monitoring.example.com";
          description = ''
            The hostname to use when configuring Postfix.

            Should correspond to the host's fully qualified domain
            name and the domain part of the email address which
            receives DMARC reports. You also have to set up an MX record
            pointing to this domain name.
          '';
        };
      };

      geoIp = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable and configure the [geoipupdate](#opt-services.geoipupdate.enable)
          service to automatically fetch GeoIP databases. Not crucial,
          but recommended for full functionality.

          To finish the setup, you need to manually set the [](#opt-services.geoipupdate.settings.AccountID) and
          [](#opt-services.geoipupdate.settings.LicenseKey)
          options.
        '';
      };

      elasticsearch = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to set up and use a local instance of Elasticsearch.
        '';
      };

      grafana = {
        datasource = lib.mkOption {
          type = lib.types.bool;
          default = cfg.provision.elasticsearch && config.services.grafana.enable;
          defaultText = lib.literalExpression ''
            config.${opt.provision.elasticsearch} && config.${options.services.grafana.enable}
          '';
          apply = x: x && cfg.provision.elasticsearch;
          description = ''
            Whether the automatically provisioned Elasticsearch
            instance should be added as a grafana datasource. Has no
            effect unless
            [](#opt-services.parsedmarc.provision.elasticsearch)
            is also enabled.
          '';
        };

        dashboard = lib.mkOption {
          type = lib.types.bool;
          default = config.services.grafana.enable;
          defaultText = lib.literalExpression "config.services.grafana.enable";
          description = ''
            Whether the official parsedmarc grafana dashboard should
            be provisioned to the local grafana instance.
          '';
        };
      };
    };

    settings = lib.mkOption {
      example = lib.literalExpression ''
        {
          imap = {
            host = "imap.example.com";
            user = "alice@example.com";
            password = { _secret = "/run/keys/imap_password" };
          };
          mailbox = {
            watch = true;
            batch_size = 30;
          };
          splunk_hec = {
            url = "https://splunkhec.example.com";
            token = { _secret = "/run/keys/splunk_token" };
            index = "email";
          };
        }
      '';
      description = ''
        Configuration parameters to set in
        {file}`parsedmarc.ini`. For a full list of
        available parameters, see
        <https://domainaware.github.io/parsedmarc/#configuration-file>.

        Settings containing secret data should be set to an attribute
        set containing the attribute `_secret` - a
        string pointing to a file containing the value the option
        should be set to. See the example to get a better picture of
        this: in the resulting {file}`parsedmarc.ini`
        file, the `splunk_hec.token` key will be set
        to the contents of the
        {file}`/run/keys/splunk_token` file.
      '';

      type = lib.types.submodule {
        freeformType = ini.type;

        options = {
          general = {
            save_aggregate = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Save aggregate report data to Elasticsearch and/or Splunk.
              '';
            };

            save_forensic = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Save forensic report data to Elasticsearch and/or Splunk.
              '';
            };
          };

          mailbox = {
            watch = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use the IMAP IDLE command to process messages as they arrive.
              '';
            };

            delete = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Delete messages after processing them, instead of archiving them.
              '';
            };
          };

          imap = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "localhost";
              description = ''
                The IMAP server hostname or IP address.
              '';
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 993;
              description = ''
                The IMAP server port.
              '';
            };

            ssl = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use an encrypted SSL/TLS connection.
              '';
            };

            user = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                The IMAP server username.
              '';
            };

            password = lib.mkOption {
              type = with lib.types; nullOr (either path (attrsOf path));
              default = null;
              description = ''
                The IMAP server password.

                Always handled as a secret whether the value is
                wrapped in a `{ _secret = ...; }`
                attrset or not (refer to [](#opt-services.parsedmarc.settings) for
                details).
              '';
              apply = x: if isAttrs x || x == null then x else { _secret = x; };
            };
          };

          smtp = {
            host = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                The SMTP server hostname or IP address.
              '';
            };

            port = lib.mkOption {
              type = with lib.types; nullOr port;
              default = null;
              description = ''
                The SMTP server port.
              '';
            };

            ssl = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = ''
                Use an encrypted SSL/TLS connection.
              '';
            };

            user = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                The SMTP server username.
              '';
            };

            password = lib.mkOption {
              type = with lib.types; nullOr (either path (attrsOf path));
              default = null;
              description = ''
                The SMTP server password.

                Always handled as a secret whether the value is
                wrapped in a `{ _secret = ...; }`
                attrset or not (refer to [](#opt-services.parsedmarc.settings) for
                details).
              '';
              apply = x: if isAttrs x || x == null then x else { _secret = x; };
            };

            from = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                The `From` address to use for the
                outgoing mail.
              '';
            };

            to = lib.mkOption {
              type = with lib.types; nullOr (listOf str);
              default = null;
              description = ''
                The addresses to send outgoing mail to.
              '';
              apply = x: if x == [ ] || x == null then null else lib.concatStringsSep "," x;
            };
          };

          elasticsearch = {
            hosts = lib.mkOption {
              default = [ ];
              type = with lib.types; listOf str;
              apply = x: if x == [ ] then null else lib.concatStringsSep "," x;
              description = ''
                A list of Elasticsearch hosts to push parsed reports
                to.
              '';
            };

            user = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                Username to use when connecting to Elasticsearch, if
                required.
              '';
            };

            password = lib.mkOption {
              type = with lib.types; nullOr (either path (attrsOf path));
              default = null;
              description = ''
                The password to use when connecting to Elasticsearch,
                if required.

                Always handled as a secret whether the value is
                wrapped in a `{ _secret = ...; }`
                attrset or not (refer to [](#opt-services.parsedmarc.settings) for
                details).
              '';
              apply = x: if isAttrs x || x == null then x else { _secret = x; };
            };

            ssl = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to use an encrypted SSL/TLS connection.
              '';
            };

            cert_path = lib.mkOption {
              type = lib.types.path;
              default = config.security.pki.caBundle;
              defaultText = lib.literalExpression "config.security.pki.caBundle";
              description = ''
                The path to a TLS certificate bundle used to verify
                the server's certificate.
              '';
            };
          };
        };

      };
    };

  };

  config = lib.mkIf cfg.enable {

    warnings =
      let
        deprecationWarning =
          optname:
          "Starting in 8.0.0, the `${optname}` option has been moved from the `services.parsedmarc.settings.imap`"
          + "configuration section to the `services.parsedmarc.settings.mailbox` configuration section.";
        hasImapOpt = lib.flip builtins.hasAttr cfg.settings.imap;
        movedOptions = [
          "reports_folder"
          "archive_folder"
          "watch"
          "delete"
          "test"
          "batch_size"
        ];
      in
      builtins.map deprecationWarning (builtins.filter hasImapOpt movedOptions);

    services.elasticsearch.enable = lib.mkDefault cfg.provision.elasticsearch;

    services.geoipupdate = lib.mkIf cfg.provision.geoIp {
      enable = true;
      settings = {
        EditionIDs = [
          "GeoLite2-ASN"
          "GeoLite2-City"
          "GeoLite2-Country"
        ];
        DatabaseDirectory = "/var/lib/GeoIP";
      };
    };

    services.dovecot2 = lib.mkIf cfg.provision.localMail.enable {
      enable = true;
      protocols = [ "imap" ];
    };

    services.postfix = lib.mkIf cfg.provision.localMail.enable {
      enable = true;
      settings.main = {
        myhostname = cfg.provision.localMail.hostname;
        myorigin = cfg.provision.localMail.hostname;
        mydestination = cfg.provision.localMail.hostname;
      };
    };

    services.grafana = {
      declarativePlugins =
        with pkgs.grafanaPlugins;
        lib.mkIf cfg.provision.grafana.dashboard [
          grafana-worldmap-panel
          grafana-piechart-panel
        ];

      provision = {
        enable = cfg.provision.grafana.datasource || cfg.provision.grafana.dashboard;
        datasources.settings.datasources =
          let
            esVersion = lib.getVersion config.services.elasticsearch.package;
          in
          lib.mkIf cfg.provision.grafana.datasource [
            {
              name = "dmarc-ag";
              type = "elasticsearch";
              access = "proxy";
              url = "http://localhost:9200";
              jsonData = {
                timeField = "date_range";
                inherit esVersion;
              };
            }
            {
              name = "dmarc-fo";
              type = "elasticsearch";
              access = "proxy";
              url = "http://localhost:9200";
              jsonData = {
                timeField = "date_range";
                inherit esVersion;
              };
            }
          ];
        dashboards.settings.providers = lib.mkIf cfg.provision.grafana.dashboard [
          {
            name = "parsedmarc";
            options.path = "${pkgs.parsedmarc.dashboard}";
          }
        ];
      };
    };

    services.parsedmarc.settings = lib.mkMerge [
      (lib.mkIf cfg.provision.elasticsearch {
        elasticsearch = {
          hosts = [ "http://localhost:9200" ];
          ssl = false;
        };
      })
      (lib.mkIf cfg.provision.localMail.enable {
        imap = {
          host = "localhost";
          port = 143;
          ssl = false;
          user = cfg.provision.localMail.recipientName;
          password = "${pkgs.writeText "imap-password" "@imap-password@"}";
        };
        mailbox = {
          watch = true;
        };
      })
    ];

    systemd.services.parsedmarc =
      let
        # Remove any empty attributes from the config, i.e. empty
        # lists, empty attrsets and null. This makes it possible to
        # list interesting options in `settings` without them always
        # ending up in the resulting config.
        filteredConfig = lib.converge (lib.filterAttrsRecursive (
          _: v:
          !elem v [
            null
            [ ]
            { }
          ]
        )) cfg.settings;

        # Extract secrets (attributes set to an attrset with a
        # "_secret" key) from the settings and generate the commands
        # to run to perform the secret replacements.
        secretPaths = lib.catAttrs "_secret" (lib.collect isSecret filteredConfig);
        parsedmarcConfig = ini.generate "parsedmarc.ini" filteredConfig;
        mkSecretReplacement = file: ''
          replace-secret ${
            lib.escapeShellArgs [
              (hashString "sha256" file)
              file
              "/run/parsedmarc/parsedmarc.ini"
            ]
          }
        '';
        secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [
          "postfix.service"
          "dovecot2.service"
          "elasticsearch.service"
        ];
        path = with pkgs; [
          replace-secret
          openssl
          shadow
        ];
        serviceConfig = {
          ExecStartPre =
            let
              startPreFullPrivileges = ''
                set -o errexit -o pipefail -o nounset -o errtrace
                shopt -s inherit_errexit

                umask u=rwx,g=,o=
                cp ${parsedmarcConfig} /run/parsedmarc/parsedmarc.ini
                chown parsedmarc:parsedmarc /run/parsedmarc/parsedmarc.ini
                ${secretReplacements}
              ''
              + lib.optionalString cfg.provision.localMail.enable ''
                openssl rand -hex 64 >/run/parsedmarc/dmarc_user_passwd
                replace-secret '@imap-password@' '/run/parsedmarc/dmarc_user_passwd' /run/parsedmarc/parsedmarc.ini
                echo "Setting new randomized password for user '${cfg.provision.localMail.recipientName}'."
                cat <(echo -n "${cfg.provision.localMail.recipientName}:") /run/parsedmarc/dmarc_user_passwd | chpasswd
              '';
            in
            "+${pkgs.writeShellScript "parsedmarc-start-pre-full-privileges" startPreFullPrivileges}";
          Type = "simple";
          User = "parsedmarc";
          Group = "parsedmarc";
          DynamicUser = true;
          RuntimeDirectory = "parsedmarc";
          RuntimeDirectoryMode = "0700";
          CapabilityBoundingSet = "";
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictRealtime = true;
          RestrictNamespaces = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
          SystemCallArchitectures = "native";
          ExecStart = "${lib.getExe pkgs.parsedmarc} -c /run/parsedmarc/parsedmarc.ini";
        };
      };

    users.users.${cfg.provision.localMail.recipientName} = lib.mkIf cfg.provision.localMail.enable {
      isNormalUser = true;
      description = "DMARC mail recipient";
    };
  };

  meta.doc = ./parsedmarc.md;
  meta.maintainers = [ lib.maintainers.talyz ];
}
