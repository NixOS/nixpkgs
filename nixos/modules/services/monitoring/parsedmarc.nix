{ config, lib, pkgs, ... }:

let
  cfg = config.services.parsedmarc;
  ini = pkgs.formats.ini {};
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
            <xref linkend="opt-services.parsedmarc.provision.localMail.recipientName" />
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
          defaultText = "config.networking.fqdn";
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
          Whether to enable and configure the <link
          linkend="opt-services.geoipupdate.enable">geoipupdate</link>
          service to automatically fetch GeoIP databases. Not crucial,
          but recommended for full functionality.

          To finish the setup, you need to manually set the <xref
          linkend="opt-services.geoipupdate.settings.AccountID" /> and
          <xref linkend="opt-services.geoipupdate.settings.LicenseKey" />
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
          apply = x: x && cfg.provision.elasticsearch;
          description = ''
            Whether the automatically provisioned Elasticsearch
            instance should be added as a grafana datasource. Has no
            effect unless
            <xref linkend="opt-services.parsedmarc.provision.elasticsearch" />
            is also enabled.
          '';
        };

        dashboard = lib.mkOption {
          type = lib.types.bool;
          default = config.services.grafana.enable;
          description = ''
            Whether the official parsedmarc grafana dashboard should
            be provisioned to the local grafana instance.
          '';
        };
      };
    };

    settings = lib.mkOption {
      description = ''
        Configuration parameters to set in
        <filename>parsedmarc.ini</filename>. For a full list of
        available parameters, see
        <link xlink:href="https://domainaware.github.io/parsedmarc/#configuration-file" />.
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
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                The path to a file containing the IMAP server password.
              '';
            };

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
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                The path to a file containing the SMTP server password.
              '';
            };

            from = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                The <literal>From</literal> address to use for the
                outgoing mail.
              '';
            };

            to = lib.mkOption {
              type = with lib.types; nullOr (listOf str);
              default = null;
              description = ''
                The addresses to send outgoing mail to.
              '';
            };
          };

          elasticsearch = {
            hosts = lib.mkOption {
              default = [];
              type = with lib.types; listOf str;
              apply = x: if x == [] then null else lib.concatStringsSep "," x;
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
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                The path to a file containing the password to use when
                connecting to Elasticsearch, if required.
              '';
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
              default = "/etc/ssl/certs/ca-certificates.crt";
              description = ''
                The path to a TLS certificate bundle used to verify
                the server's certificate.
              '';
            };
          };

          kafka = {
            hosts = lib.mkOption {
              default = [];
              type = with lib.types; listOf str;
              apply = x: if x == [] then null else lib.concatStringsSep "," x;
              description = ''
                A list of Apache Kafka hosts to publish parsed reports
                to.
              '';
            };

            user = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                Username to use when connecting to Kafka, if
                required.
              '';
            };

            password = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                The path to a file containing the password to use when
                connecting to Kafka, if required.
              '';
            };

            ssl = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = ''
                Whether to use an encrypted SSL/TLS connection.
              '';
            };

            aggregate_topic = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              example = "aggregate";
              description = ''
                The Kafka topic to publish aggregate reports on.
              '';
            };

            forensic_topic = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              example = "forensic";
              description = ''
                The Kafka topic to publish forensic reports on.
              '';
            };
          };

        };

      };
    };

  };

  config = lib.mkIf cfg.enable {

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
      origin = cfg.provision.localMail.hostname;
      config = {
        myhostname = cfg.provision.localMail.hostname;
        mydestination = cfg.provision.localMail.hostname;
      };
    };

    services.grafana = {
      declarativePlugins = with pkgs.grafanaPlugins;
        lib.mkIf cfg.provision.grafana.dashboard [
          grafana-worldmap-panel
          grafana-piechart-panel
        ];

      provision = {
        enable = cfg.provision.grafana.datasource || cfg.provision.grafana.dashboard;
        datasources =
          let
            pkgVer = lib.getVersion config.services.elasticsearch.package;
            esVersion =
              if lib.versionOlder pkgVer "7" then
                "60"
              else if lib.versionOlder pkgVer "8" then
                "70"
              else
                throw "When provisioning parsedmarc grafana datasources: unknown Elasticsearch version.";
          in
            lib.mkIf cfg.provision.grafana.datasource [
              {
                name = "dmarc-ag";
                type = "elasticsearch";
                access = "proxy";
                url = "localhost:9200";
                jsonData = {
                  timeField = "date_range";
                  inherit esVersion;
                };
              }
              {
                name = "dmarc-fo";
                type = "elasticsearch";
                access = "proxy";
                url = "localhost:9200";
                jsonData = {
                  timeField = "date_range";
                  inherit esVersion;
                };
              }
            ];
        dashboards = lib.mkIf cfg.provision.grafana.dashboard [{
          name = "parsedmarc";
          options.path = "${pkgs.python3Packages.parsedmarc.dashboard}";
        }];
      };
    };

    services.parsedmarc.settings = lib.mkMerge [
      (lib.mkIf cfg.provision.elasticsearch {
        elasticsearch = {
          hosts = [ "localhost:9200" ];
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
        filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! builtins.elem v [ null [] {} ])) cfg.settings;
        parsedmarcConfig = ini.generate "parsedmarc.ini" filteredConfig;
        mkSecretReplacement = file:
          lib.optionalString (file != null) ''
            replace-secret '${file}' '${file}' /run/parsedmarc/parsedmarc.ini
          '';
      in
        {
          wantedBy = [ "multi-user.target" ];
          after = [ "postfix.service" "dovecot2.service" "elasticsearch.service" ];
          path = with pkgs; [ replace-secret openssl shadow ];
          serviceConfig = {
            ExecStartPre = let
              startPreFullPrivileges = ''
                set -o errexit -o pipefail -o nounset -o errtrace
                shopt -s inherit_errexit

                umask u=rwx,g=,o=
                cp ${parsedmarcConfig} /run/parsedmarc/parsedmarc.ini
                chown parsedmarc:parsedmarc /run/parsedmarc/parsedmarc.ini
                ${mkSecretReplacement cfg.settings.smtp.password}
                ${mkSecretReplacement cfg.settings.imap.password}
                ${mkSecretReplacement cfg.settings.elasticsearch.password}
                ${mkSecretReplacement cfg.settings.kafka.password}
              '' + lib.optionalString cfg.provision.localMail.enable ''
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
            RuntimeDirectoryMode = 0700;
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
            SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
            RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
            RestrictRealtime = true;
            RestrictNamespaces = true;
            MemoryDenyWriteExecute = true;
            LockPersonality = true;
            SystemCallArchitectures = "native";
            ExecStart = "${pkgs.python3Packages.parsedmarc}/bin/parsedmarc -c /run/parsedmarc/parsedmarc.ini";
          };
        };

    users.users.${cfg.provision.localMail.recipientName} = lib.mkIf cfg.provision.localMail.enable {
      isNormalUser = true;
      description = "DMARC mail recipient";
    };
  };

  # Don't edit the docbook xml directly, edit the md and generate it:
  # `pandoc parsedmarc.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart > parsedmarc.xml`
  meta.doc = ./parsedmarc.xml;
  meta.maintainers = [ lib.maintainers.talyz ];
}
