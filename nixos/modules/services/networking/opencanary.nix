{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    attrNames
    filterAttrs
    mdDoc
    mergeAttrsList
    mkIf
    mkMerge
    mkOption
    mkEnableOption
    mkPackageOption
    optional
    optionalAttrs
    recursiveUpdate
    stringLength
    types
    ;

  apparmor = config.security.apparmor.enable;
  cfg = config.services.opencanary;
  json = pkgs.formats.json {};

  generatedConfig = json.generate "opencanary.conf" (
    recursiveUpdate
      {
        "device.node_id" = cfg.settings.networking.hostName;
        "ip.ignorelist" = cfg.settings.networking.ignoredIPs;
        logger.class = "PyLogger";
      }

      (with cfg.services.ftp; optionalAttrs (enable) {
        "ftp.enabled" = true;
        "ftp.banner" = banner;
        "ftp.port" = port;
      })
      //
      (with cfg.services.git; optionalAttrs (enable) {
        "git.enabled" = true;
        "git.port" = port;
      })
      //
      (with cfg.services.mssql; optionalAttrs (enable) {
        "mssql.enabled" = true;
        "mssql.port" = port;
        "mssql.version" = version;
      })
      //
      (with cfg.services.mysql; optionalAttrs (enable) {
        "mysql.enabled" = true;
        "mysql.banner" = banner;
        "mysql.port" = port;
      })
      //
      (with cfg.services.ntp; optionalAttrs (enable) {
        "ntp.enabled" = true;
        "ntp.port" = port;
      })
      //
      (with cfg.services.portscan; optionalAttrs (enable) {
        "portscan.enabled" = true;
        "portscan.ignore_localhost" = ignoreLocalhost;
        "portscan.ignore_ports" = ignorePorts;
        "portscan.logfile" = logFile;
        "portscan.lorate" = logRate;
        "portscan.nmaposrate" = osScanRate;
        "portscan.synrate" = synRate;
      })
      //
      (with cfg.services.rdp; optionalAttrs (enable) {
        "rdp.enabled" = true;
        "rdp.port" = port;
      })
      //
      (with cfg.services.redis; optionalAttrs (enable) {
        "redis.enabled" = true;
        "redis.port" = port;
      })
      //
      (with cfg.services.samba; optionalAttrs (enable) {
        "smb.enabled" = true;
        "smb.auditfile" = auditFile;
      })
      //
      (with cfg.services.sip; optionalAttrs (enable) {
        "sip.enabled" = true;
        "sip.port" = port;
      })
      //
      (with cfg.services.snmp; optionalAttrs (enable) {
        "snmp.enabled" = true;
        "snmp.port" = port;
      })
      //
      (with cfg.services.ssh; optionalAttrs (enable) {
        "ssh.enabled" = true;
        "ssh.port" = port;
        "ssh.version" = version;
      })
      //
      (with cfg.services.tcpBanner; optionalAttrs (enable) ({
        "tcpbanner.enabled" = true;
        "tcpbanner.maxnum" = count (attrNames banners);
      } // (
        mapAttrs' (name: value:
          nameValuePair ("tcpbanner_" + name)
          (with value; {
            enabled = enable;
            port = port;
            datareceivedbanner = message.dataReceived;
            initbanner = message.init;
            "alertstring.enabled" = alert.enable;
            alertstring = alert.text;
          })
        )
        banners)
      ))
      //
      (with cfg.services.telnet; optionalAttrs (enable) {
        "telnet.enabled" = true;
        "telnet.port" = port;
        "telnet.honeycreds" = credentials;
      })
      //
      (with cfg.services.tftp; optionalAttrs (enable) {
        "tftp.enabled" = true;
        "tftp.port" = port;
      })
      //
      (with cfg.services.vnc; optionalAttrs (enable) {
        "vnc.enabled" = true;
        "vnc.port" = port;
      })
      //
      (with cfg.services.website; optionalAttrs (enable) (mergeAttrsList [
        (with http; optionalAttrs (enable) {
          "http.enabled" = true;
          "http.banner" = banner;
          "http.port" = port;
          "http.skin" = skin;
          "http.skin.list" = [
            { desc = "Plain HTML Login";
              name = "basicLogin"; }
            { desc = "Synology NAS Login";
              name = "nasLogin"; }
          ];
        })
        (with https; optionalAttrs (enable) {
          "https.enabled" = true;
          "https.port" = port;
          "https.skin" = skin;
          "https.certificate" = certFile;
          "https.key" = keyFile;
        })
        (with http.proxy; optionalAttrs (enable) {
          "httpproxy.enabled" = true;
          "httpproxy.port" = port;
          "httpproxy.skin" = skin;
          "httpproxy.skin.list" = [
            { desc = "Squid";
              name = "squid"; }
            { desc = "Microsoft ISA Server Web Proxy";
              name = "ms-isa"; }
          ];
        })
      ]))
      //
      (with cfg.settings; optionalAttrs (logs.enable) {
        "logtype.ignorelist" = logs.ignoreCodes;
        logger.class = "PyLogger";
        logger.kwargs.formatters = with logs.formatters; {
          plain.format = plain;
          syslog_rfc.format = syslog;
        };
        logger.kwargs.handlers = with logs.handlers; mergeAttrsList [
          (with console; optionalAttrs (enable) {
            console = {
              class = "logging.StreamHandler";
              inherit stream;
            };
          })
          (with file; optionalAttrs (enable) {
            file = {
              class = "logging.FileHandler";
              filename = fileName;
            };
          })
          (with json-tcp; optionalAttrs (enable) {
            json-tcp = {
              class = "opencanary.logger.SocketJSONHandler";
              inherit host port;
            };
          })
          (with slack; optionalAttrs (enable) {
            slack = {
              class = "opencanary.logger.SlackHandler";
              webhook_url = webhookUrl;
            };
          })
          (with SMTP; optionalAttrs (enable) {
            SMTP = {
              class = "logging.handlers.SMTPHandler";
              inherit subject;
              mailhost = [ host port ];
              fromaddr = sender;
              toaddrs = receivers;
            } // optionalAttrs (credentials != {}) {
              credentials = with credentials; [ username password ];
            } // optionalAttrs (tls.enable) {
              secure = optional (tls.certFile != null) tls.certFile
                    ++ optional (tls.keyFile != null) tls.keyFile;
            };
          })
          (with syslog; optionalAttrs (enable) {
            syslog-unix = {
              class = "logging.handlers.SysLogHandler";
              inherit formatter host port;
            };
          })
          (with teams; optionalAttrs (enable) {
            teams = {
              class = "opencanary.logger.TeamsHandler";
              webhook_url = webhookUrl;
            };
          })
          (with webhook; optionalAttrs (enable) {
            Webhook = {
              class = "opencanary.logger.WebhookHandler";
              inherit method url;
              data.message = getAttr formatter logs.formatters;
              status_code = statusCode;
              ignore = optionals (ignoreCodes != []) (
                map (code: "logtype: ${toString code}") ignoreCodes
              );
            };
          })
        ];
      })
  );

  servicesModule = {
    options = {
      ftp = {
        enable = mkEnableOption "the FTP service";
        banner = mkOption {
          type = types.str;
          default = "FTP server ready";
          description = "The banner to show on FTP connections.";
        };
        port = mkOption {
          type = types.port;
          default = 21;
          description = "The port number to use for the FTP service.";
        };
      };

      git = {
        enable = mkEnableOption "the Git service";
        port = mkOption {
          type = types.port;
          default = 9418;
          description = "The port number to use for the Git service.";
        };
      };

      mssql = {
        enable = mkEnableOption "the MSSQL service";
        port = mkOption {
          type = types.port;
          default = 1433;
          description = "The port number to use for the MSSQL service.";
        };
        version = mkOption {
          type = types.str;
          default = "2012";
          description = "The version to display for connections.";
        };
      };

      mysql = {
        enable = mkEnableOption "the MySQL service";
        port = mkOption {
          type = types.port;
          default = 3306;
          description = "The port number to use for the MySQL service.";
        };
        banner = mkOption {
          type = types.str;
          default = "5.5.43-0ubuntu0.14.04.1";
          description = "The banner to display for connections.";
        };
      };

      ntp = {
        enable = mkEnableOption "the NTP service";
        port = mkOption {
          type = types.port;
          default = 123;
          description = "The port number to use for the NTP service.";
        };
      };

      portscan = {
        enable = mkEnableOption "port scanning detection";
        ignoreLocalhost = mkEnableOption "ignoring scans from the local host";
        ignorePorts = mkOption {
          type = types.listOf types.port;
          default = [];
          description = "The ports to ignore for scan detection.";
          example = [ 52 80 443 ];
        };
        logFile = mkOption {
          type = types.str;
          default = "${cfg.stateDir.logs.path}/portscan.log";
          defaultText = "\${config.services.opencanary.stateDir.logs.path}/portscan.log";
          description = "The directory to write port scanning logs to.";
          example = "/var/log/portscan.log";
        };
        logRate = mkOption {
          type = types.int;
          default = 3;
          description = "The rate at which logs should be sent.";
        };
        synRate = mkOption {
          type = types.int;
          default = 5;
          description = "The rate of syn packets (per second) at which a log event will be triggered.";
        };
        osScanRate = mkOption {
          type = types.int;
          default = 5;
          description = ''
            The rate of OS Detection packets (per second) at which a log event will be triggered.
            The iptables rules that are created account for the common TCP flags/options used
            by nmap for OS Detection scans.
          '';
        };
      };

      rdp = {
        enable = mkEnableOption "the RDP service";
        port = mkOption {
          type = types.port;
          default = 3389;
          description = "The port number to use for the RDP service.";
        };
      };

      redis = {
        enable = mkEnableOption "the Redis service";
        port = mkOption {
          type = types.port;
          default = 6379;
          description = "The port number to use for the Redis service.";
        };
      };

      samba = {
        enable = mkEnableOption "the SMB service";
        auditFile = mkOption {
          type = types.str;
          default = "${cfg.stateDir.logs.path}/samba-audit.log";
          defaultText = "\${config.services.opencanary.stateDir.logs.path}/samba-audit.log";
          description = "The path to write the audit log to.";
        };
      };

      sip = {
        enable = mkEnableOption "the SIP service";
        port = mkOption {
          type = types.port;
          default = 5060;
          description = "The port number to use for the SIP service.";
        };
      };

      snmp = {
        enable = mkEnableOption "the SNMP service";
        port = mkOption {
          type = types.port;
          default = 161;
          description = "The port number to use for the SNMP service.";
        };
      };

      ssh = {
        enable = mkEnableOption "the SSH service";
        port = mkOption {
          type = types.port;
          default = 22;
          description = "The port number to use for the SSH service.";
        };
        version = mkOption {
          type = types.str;
          default = "SSH-2.0-OpenSSH_5.1p1 Debian-4";
          description = "The banner to display for connections.";
        };
      };

      tcpBanner = {
        enable = mkEnableOption "the TCP Banner service";
        banners = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              enable = mkEnableOption "this banner's configuration";
              alert = {
                enable = mkEnableOption "this banner's alert";
                text = mkOption {
                  type = types.str;
                  description = "The alert text for the banner.";
                };
              };
              message = {
                dataReceived = mkOption {
                  type = types.str;
                  description = "The message to respond with when data has been received.";
                };
                init = mkOption {
                  type = types.str;
                  description = "The message to respond with when initializing.";
                };
              };
              port = mkOption {
                type = types.port;
                description = "The port number to use for this banner.";
                example = 8001;
              };
            };
          });
          default = {};
          description = "The TCP banners to configure.";
          example = {
            normal = {
              enable = true;
              port = 8001;
            };
          };
        };
      };

      telnet = {
        enable = mkEnableOption "the Telnet service";
        port = mkOption {
          type = types.port;
          default = 23;
          description = "The port number to use for the Telnet service.";
        };
        credentials = mkOption {
          type = types.listOf (types.submodule {
            options = {
              username = mkOption {
                type = types.str;
                description = "The username to use for this credential.";
              };
              password = mkOption {
                type = types.str;
                description = "The password to use for this credential.";
              };
            };
          });
          default = [{
            username = "admin";
            password = "admin";
          }];
          description = "A list of credentials that are able to log in.";
        };
      };

      tftp = {
        enable = mkEnableOption "the TFTP service";
        port = mkOption {
          type = types.port;
          default = 69;
          description = "The port number to use for the TFTP service.";
        };
      };

      vnc = {
        enable = mkEnableOption "the VNC service";
        port = mkOption {
          type = types.port;
          default = 5000;
          description = "The port number to use for the VNC service.";
        };
      };

      website = {
        enable = mkEnableOption "the website service";
        domain = mkOption {
          type = types.str;
          default = "localhost";
          description = "The FQDN to host the website on.";
          example = "127.0.0.1";
        };

        http = {
          enable = mkEnableOption "HTTP for the website";
          banner = mkOption {
            type = types.str;
            default = "Apache/2.2.22 (Ubuntu)";
            description = "The banner to show on HTTP connections.";
          };
          port = mkOption {
            type = types.port;
            default = 80;
            description = "The port number to use for HTTP connections.";
          };
          proxy = {
            enable = mkEnableOption "the HTTP Proxy for the website";
            port = mkOption {
              type = types.port;
              default = 8080;
              description = "The port number to use for HTTP proxy connections.";
            };
            skin = mkOption {
              type = types.enum [ "squid" "ms-isa" ];
              default = "squid";
              description = "The skin to use for the website.";
            };
          };
          skin = mkOption {
            type = types.enum [ "basicLogin" "nasLogin" ];
            default = "basicLogin";
            description = "The skin to use for the website.";
          };
        };

        https = {
          enable = mkEnableOption "HTTP for the website";
          generateCertificate = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = mdDoc ''
                Enables generating a self-signed SSL certificate and private
                key pair if they are not already present at the paths provided
                by the `certFile` and `keyFile` options.
              '';
            };
            subject = {
              country = mkOption {
                type = types.addCheck types.str (s: (stringLength s) == 2);
                default = "US";
                description = "A 2-letter country code.";
              };
              state = mkOption {
                type = types.str;
                default = "California";
                description = "A state or province name.";
              };
              city = mkOption {
                type = types.str;
                default = "San Francisco";
                description = "A city or locality name.";
              };
              organization = mkOption {
                type = types.str;
                default = "Synology Inc. CA";
                description = "An organization name.";
              };
              commonName = mkOption {
                type = types.str;
                default = cfg.services.website.domain;
                defaultText = "config.services.opencanary.services.website.domain";
                description = "The server FQDN or your name.";
              };
              text = mkOption {
                type = types.str;
                default = with cfg.services.website.https.generateCertificate.subject;
                  "/C=${country}/ST=${state}/L=${city}/O=${organization}/CN=${commonName}";
                internal = true;
                visible = false;
              };
            };
          };
          certFile = mkOption {
            type = types.str;
            default = "${cfg.stateDir.ssl.path}/opencanary.crt";
            defaultText = "\${config.services.opencanary.stateDir.ssl.path}/opencanary.crt";
            description = "The path to the certificate to use for the website.";
            example = "/etc/ssl/domain.crt";
          };
          keyFile = mkOption {
            type = types.str;
            default = "${cfg.stateDir.ssl.path}/opencanary.key";
            defaultText = "\${config.services.opencanary.stateDir.ssl.path}/opencanary.key";
            description = "The path to the private key to use for the website.";
            example = "/etc/ssl/domain.key";
          };
          port = mkOption {
            type = types.port;
            default = 443;
            description = "The port number to use for HTTPS connections.";
          };
          skin = mkOption {
            type = types.enum [ "basicLogin" "nasLogin" ];
            default = "basicLogin";
            description = "The skin to use for the website.";
          };
        };
      };
    };
  };

  settingsModule = {
    options = {
      logs = {
        enable = mkEnableOption "event logging";

        ignoreCodes = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            A list of log codes to ignore. See the list of available codes here:
            https://github.com/thinkst/opencanary/blob/master/opencanary/logger.py#L56
          '';
          example = [ 1000 1001 ];
        };

        handlers = {
          console = {
            enable = mkEnableOption "sending logs to a standard stream (i.e. stdout)";
            formatter = mkOption {
              type = types.enum (attrNames cfg.settings.logs.formatters);
              default = "plain";
              internal = true;
              visible = false;
            };
            stream = mkOption {
              type = types.str;
              default = "ext://sys.stdout";
              description = "The standard stream to send logs to.";
            };
          };

          file = {
            enable = mkEnableOption "writing logs to a local directory";
            fileName = mkOption {
              type = types.str;
              default = "${cfg.stateDir.logs.path}/opencanary.log";
              defaultText = "\${config.services.opencanary.stateDir.logs.path}/opencanary.log";
              description = "The path to write log files to.";
              example = "/var/log";
            };
          };

          json-tcp = {
            enable = mkEnableOption "sending logs as JSON to a TCP socket";
            host = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = "The host to send logs to.";
            };
            port = mkOption {
              type = types.port;
              default = 1514;
              description = "The port to use for this host.";
            };
          };

          slack = {
            enable = mkEnableOption "sending logs to a Slack webhook";
            webhookUrl = mkOption {
              type = types.str;
              description = "The Slack webhook URL to send logs to.";
              example = "https://hooks.slack.com/...";
            };
          };

          SMTP = {
            enable = mkEnableOption "sending logs as emails";
            host = mkOption {
              type = types.str;
              description = "The mail server to send logs to.";
              example = "smtp.example.com";
            };
            port = mkOption {
              type = types.port;
              default = 25;
              description = "The port to use for this host.";
            };
            sender = mkOption {
              type = types.str;
              description = "The email address to send logs from.";
              example = "noreply@yourdomain.com";
            };
            receivers = mkOption {
              type = types.listOf types.str;
              description = "A list of one or more email addresses to send logs to.";
              example = [ "support@example.com" ];
            };
            subject = mkOption {
              type = types.str;
              default = "OpenCanary Alert";
              description = "The subject to use for all sent emails.";
            };
            credentials = mkOption {
              type = types.submodule {
                options = {
                  username = mkOption {
                    type = types.str;
                    description = "The username to login to the SMTP server as.";
                  };
                  password = mkOption {
                    type = types.str;
                    description = "The password to login to the SMTP server with.";
                  };
                };
              };
              default = {};
              description = "The credentials to login to the SMTP server with.";
              example = {
                credentials = {
                  username = "example";
                  password = "password";
                };
              };
            };
            tls = {
              enable = mkEnableOption "SMTP over TLS";
              certFile = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The path to the TLS certificate to use.";
              };
              keyFile = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The path to the TLS private key to use.";
              };
            };
          };

          syslog = {
            enable = mkEnableOption "sending logs to a Syslog server";
            formatter = mkOption {
              type = types.enum (attrNames cfg.settings.logs.formatters);
              default = "syslog";
              internal = true;
              visible = false;
            };
            host = mkOption {
              type = types.str;
              description = "The Syslog server to send logs to.";
              example = "127.0.0.1";
            };
            port = mkOption {
              type = types.port;
              default = 514;
              description = "The port to use for this host.";
              example = 6514;
            };
          };

          teams = {
            enable = mkEnableOption "sending logs to a Microsoft Teams webhook";
            webhookUrl = mkOption {
              type = types.str;
              description = "The Slack webhook URL to send logs to.";
              example = "https://example.webhook.office.com/webhookb2/...";
            };
          };

          webhook = {
            enable = mkEnableOption "sending logs to an arbitrary webhook url";
            formatter = mkOption {
              type = types.enum (attrNames cfg.settings.logs.formatters);
              default = "plain";
              internal = true;
              visible = false;
            };
            method = mkOption {
              type = types.enum [ "POST" ];
              default = "POST";
              description = "The method to use when sending requests.";
            };
            statusCode = mkOption {
              type = types.addCheck types.int (x: x <= 600);
              default = 200;
              description = "The status code to use when sending requests.";
            };
            url = mkOption {
              type = types.str;
              description = "The webhook URL to send logs to.";
              example = "https://example.com/webhook";
            };
            ignoreCodes = mkOption {
              type = types.listOf types.int;
              default = [];
              description = ''
                A list of log codes to ignore. See the list of available codes here:
                https://github.com/thinkst/opencanary/blob/master/opencanary/logger.py#L56
              '';
              example = [ 1000 1001 ];
            };
          };
        };

        formatters = {
          plain = mkOption {
            type = types.str;
            default = "%(message)s";
            description = "Formats logs in a simple message-only format.";
          };
          syslog = mkOption {
            type = types.str;
            default = "opencanaryd[%(process)-5s:%(thread)d]: %(name)s %(levelname)-5s %(message)s";
            description = "Formats logs in the standard Syslog RFC format.";
          };
        };
      };

      networking = {
        hostName = mkOption {
          type = types.str;
          default = config.networking.hostName;
          defaultText = "config.networking.hostName";
          description = "The networking hostname of the machine.";
          example = "workstation-1";
        };
        ignoredIPs = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "A list of IP addresses to ignore.";
        };
      };
    };
  };
in
{
  # NOTE: option definitions
  options.services.opencanary = {
    enable = mkEnableOption "the OpenCanary service";

    package = mkPackageOption pkgs "opencanary" {};

    user = mkOption {
      type = types.str;
      default = "opencanaryd";
      description = "The user to run the OpenCanary services as.";
      example = "root";
    };

    group = mkOption {
      type = types.str;
      default = "opencanaryd";
      description = "The group to run the OpenCanary services as.";
      example = "root";
    };

    services = mkOption {
      type = types.submodule servicesModule;
      default = {};
      description = "The settings for configuring the OpenCanary services.";
      example = {
        git.enable = true;
        website = {
          enable = true;
          http.enable = true;
          https = {
            enable = true;
            certFile = "path/to/some.crt";
            keyFile = "path/to/some.key";
          };
        };
      };
    };

    settings = mkOption {
      type = types.submodule settingsModule;
      default = {};
      description = "The settings for configuring the OpenCanary daemon.";
      example = {
        logs = {
          enable = true;
          handlers = {
            file = {
              enable = true;
              fileName = "/tmp/log/opencanary.log";
            };
          };
        };
        networking = {
          hostName = "opencanary-1";
          ignoredIPs = [ "10.0.0.1" ];
        };
      };
    };

    stateDir = {
      path = mkOption {
        type = types.str;
        description = "The directory to store application state in.";
        default = "/var/lib/opencanaryd";
      };
      logs.path = mkOption {
        type = types.str;
        description = "The directory to store all logs in.";
        default = "/var/log/opencanaryd";
        example = "/var/lib/opencanary/logs";
      };
      ssl.path = mkOption {
        type = types.str;
        description = "The directory to store SSL certificates in.";
        default = "/etc/opencanaryd/ssl";
        example = "/var/lib/opencanary/ssl";
      };
    };
  };


  # NOTE: implementation
  config = mkIf cfg.enable (mkMerge [
    {
      assertions = let
        opt = name: "services.opencanary.${name}";
        tcpBannerOpt = opt "services.tcpBanner";
        websiteOpt = opt "services.website";
      in [
        {
          assertion = with cfg.services.tcpBanner; enable -> (banners != {});
          message = ''
            The option `${tcpBannerOpt}.banners` must not be empty for
            `${tcpBannerOpt}.enable` to have any effect.
          '';
        }
        {
          assertion = with cfg.services.tcpBanner; (banners != {}) -> enable;
          message = ''
            The option `${tcpBannerOpt}.banners` requires that
            `${tcpBannerOpt}.enable` is `true`.
          '';
        }
        {
          assertion = with cfg.services.website; enable -> (http.enable || https.enable);
          message = ''
            The option `${websiteOpt}.enable` requires one of the following options
            to be set to have any effect:

            - `${websiteOpt}.http.enable = true`
            - `${websiteOpt}.https.enable = true`
          '';
        }
      ];
    }

    {
      environment.etc."opencanaryd/opencanary.conf" = {
        source = generatedConfig;
        user = "opencanaryd";
        group = "opencanaryd";
        mode = "0400";
      };

      environment.systemPackages = [ cfg.package ];

      users = {
        users.${cfg.user} = {
          description = "OpenCanary daemon user";
          group = cfg.group;
          isSystemUser = true;
        };
        groups.${cfg.group} = {};
      };

      systemd.services =
      let enabled = filterAttrs (_: v: v.enable or false) cfg.services;
      in optionalAttrs (enabled != {}) {
        opencanaryd = {
          description = "OpenCanary daemon";
          after = [ "networking.target" ]
            ++ optional (apparmor) "apparmor.service";
          requires = optional (apparmor) "apparmor.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = rec {
            Type = "exec";
            User = cfg.user;
            Group = cfg.group;
            ExecStart = "${cfg.package}/bin/opencanaryd --dev";
            Restart = "always";
            RestartSec = 3;
            ConfigurationDirectory = "opencanaryd/ssl";
            LogsDirectory = "opencanaryd";
            StateDirectory = "opencanaryd";
            WorkingDirectory = "/var/lib/${StateDirectory}";

            # NOTE: hardening
            AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
            CapabilityBoundingSet = AmbientCapabilities;
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProtectControlGroups = true;
            ProtectHome = "yes";
            ProtectHostname = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "full";
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallFilter = "@system-service";
            SystemCallArchitectures = "native";
          };
        };
      };
    }

    (with cfg.services.website; {
      systemd.services = mkIf (https.generateCertificate.enable) {
        opencanary-certs = {
          description = "OpenCanary certificate generation";
          before = [ "opencanaryd.service" ];
          wantedBy = [ "opencanaryd.service" ];
          after = optional (apparmor) "apparmor.service";
          requires = optional (apparmor) "apparmor.service";

          path = with pkgs; [ openssl ];
          script = let
            inherit (https.generateCertificate) subject;
            outPath = cfg.stateDir.ssl.path;
          in ''
            set -euo pipefail
            [[ -e "${https.certFile}" || -e "${https.keyFile}" ]] && exit
            echo "Generating SSL certificates in ${outPath}"
            openssl req \
              -newkey rsa:2048 \
              -subj "${subject.text}" \
              -nodes \
              -x509 \
              -days 365 \
              -keyout ${outPath}/opencanary.key \
              -out ${outPath}/opencanary.crt
          '';
          serviceConfig = {
            Type = "simple";
            Restart = "on-failure";
            User = cfg.user;
            Group = cfg.group;
          };
        };
      };
    })
  ]);
}
