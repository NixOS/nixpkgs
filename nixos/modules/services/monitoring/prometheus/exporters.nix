{
  config,
  pkgs,
  lib,
  options,
  utils,
  ...
}:

with (import ./mk-exporter.nix config.networking.nftables.enable lib pkgs);

let
  inherit (lib)
    concatStrings
    foldl
    foldl'
    genAttrs
    literalExpression
    maintainers
    mapAttrs
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    types
    mkOptionDefault
    flip
    attrNames
    xor
    ;

  cfg = config.services.prometheus.exporters;

  # each attribute in `exporterOpts` is expected to have specified:
  #   - port        (types.int):   port on which the exporter listens
  #   - serviceOpts (types.attrs): config that is merged with the
  #                                default definition of the exporter's
  #                                systemd service
  #   - extraOpts   (types.attrs): extra configuration options to
  #                                configure the exporter with, which
  #                                are appended to the default options
  #
  #  Note that `extraOpts` is optional, but a script for the exporter's
  #  systemd service must be provided by specifying either
  #  `serviceOpts.script` or `serviceOpts.serviceConfig.ExecStart`

  exporterOpts =
    (genAttrs
      [
        "apcupsd"
        "artifactory"
        "bind"
        "bird"
        "bitcoin"
        "blackbox"
        "borgmatic"
        "buildkite-agent"
        "ecoflow"
        "chrony"
        "collectd"
        "deluge"
        "dmarc"
        "dnsmasq"
        "dnssec"
        "domain"
        "dovecot"
        "ebpf"
        "fastly"
        "flow"
        "fritz"
        "fritzbox"
        "frr"
        "graphite"
        "idrac"
        "imap-mailstat"
        "influxdb"
        "ipmi"
        "jitsi"
        "json"
        "junos-czerwonk"
        "kea"
        "keylight"
        "klipper"
        "knot"
        "libvirt"
        "lnd"
        "mail"
        "mailman3"
        "mikrotik"
        "modemmanager"
        "mongodb"
        "mqtt"
        "mysqld"
        "nats"
        "nextcloud"
        "nginx"
        "nginxlog"
        "node"
        "node-cert"
        "nut"
        "nvidia-gpu"
        "pgbouncer"
        "php-fpm"
        "pihole"
        "ping"
        "postfix"
        "postgres"
        "process"
        "pve"
        "py-air-control"
        "rasdaemon"
        "redis"
        "restic"
        "rspamd"
        "rtl_433"
        "sabnzbd"
        "scaphandre"
        "script"
        "shelly"
        "smartctl"
        "smokeping"
        "snmp"
        "sql"
        "statsd"
        "surfboard"
        "systemd"
        "tibber"
        "unbound"
        "unpoller"
        "v2ray"
        "varnish"
        "wireguard"
        "zfs"
      ]
      (
        name:
        import (./. + "/exporters/${name}.nix") {
          inherit
            config
            lib
            pkgs
            options
            utils
            ;
        }
      )
    )
    // (mapAttrs
      (
        name: params:
        import (./. + "/exporters/${params.name}.nix") {
          inherit
            config
            lib
            pkgs
            options
            utils
            ;
          type = params.type;
        }
      )
      {
        exportarr-bazarr = {
          name = "exportarr";
          type = "bazarr";
        };
        exportarr-lidarr = {
          name = "exportarr";
          type = "lidarr";
        };
        exportarr-prowlarr = {
          name = "exportarr";
          type = "prowlarr";
        };
        exportarr-radarr = {
          name = "exportarr";
          type = "radarr";
        };
        exportarr-readarr = {
          name = "exportarr";
          type = "readarr";
        };
        exportarr-sonarr = {
          name = "exportarr";
          type = "sonarr";
        };
      }
    );

  mkSubModules = (
    foldl' (a: b: a // b) { } (
      mapAttrsToList (
        name: opts:
        mkSubModule {
          inherit name;
          inherit (opts) port;
          extraOpts = opts.extraOpts or { };
          imports = opts.imports or [ ];
        }
      ) exporterOpts
    )
  );
in
{

  options.services.prometheus.exporters = mkOption {
    type = types.submodule {
      options = (mkSubModules);
      imports = [
        ../../../misc/assertions.nix
        (lib.mkRenamedOptionModule [ "unifi-poller" ] [ "unpoller" ])
        (lib.mkRemovedOptionModule [ "minio" ] ''
          The Minio exporter has been removed, as it was broken and unmaintained.
          See the 24.11 release notes for more information.
        '')
        (lib.mkRemovedOptionModule [ "tor" ] ''
          The Tor exporter has been removed, as it was broken and unmaintained.
        '')
      ];
    };
    description = "Prometheus exporter configuration";
    default = { };
    example = literalExpression ''
      {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
        varnish.enable = true;
      }
    '';
  };

  config = mkMerge (
    [
      {
        assertions =
          [
            {
              assertion =
                cfg.ipmi.enable -> (cfg.ipmi.configFile != null) -> (!(lib.hasPrefix "/tmp/" cfg.ipmi.configFile));
              message = ''
                Config file specified in `services.prometheus.exporters.ipmi.configFile' must
                  not reside within /tmp - it won't be visible to the systemd service.
              '';
            }
            {
              assertion =
                cfg.ipmi.enable
                -> (cfg.ipmi.webConfigFile != null)
                -> (!(lib.hasPrefix "/tmp/" cfg.ipmi.webConfigFile));
              message = ''
                Config file specified in `services.prometheus.exporters.ipmi.webConfigFile' must
                  not reside within /tmp - it won't be visible to the systemd service.
              '';
            }
            {
              assertion =
                cfg.restic.enable -> ((cfg.restic.repository == null) != (cfg.restic.repositoryFile == null));
              message = ''
                Please specify either 'services.prometheus.exporters.restic.repository'
                  or 'services.prometheus.exporters.restic.repositoryFile'.
              '';
            }
            {
              assertion =
                cfg.snmp.enable -> ((cfg.snmp.configurationPath == null) != (cfg.snmp.configuration == null));
              message = ''
                Please ensure you have either `services.prometheus.exporters.snmp.configuration'
                  or `services.prometheus.exporters.snmp.configurationPath' set!
              '';
            }
            {
              assertion =
                cfg.mikrotik.enable -> ((cfg.mikrotik.configFile == null) != (cfg.mikrotik.configuration == null));
              message = ''
                Please specify either `services.prometheus.exporters.mikrotik.configuration'
                  or `services.prometheus.exporters.mikrotik.configFile'.
              '';
            }
            {
              assertion = cfg.mail.enable -> ((cfg.mail.configFile == null) != (cfg.mail.configuration == null));
              message = ''
                Please specify either 'services.prometheus.exporters.mail.configuration'
                  or 'services.prometheus.exporters.mail.configFile'.
              '';
            }
            {
              assertion = cfg.mysqld.runAsLocalSuperUser -> config.services.mysql.enable;
              message = ''
                The exporter is configured to run as 'services.mysql.user', but
                  'services.mysql.enable' is set to false.
              '';
            }
            {
              assertion =
                cfg.nextcloud.enable -> ((cfg.nextcloud.passwordFile == null) != (cfg.nextcloud.tokenFile == null));
              message = ''
                Please specify either 'services.prometheus.exporters.nextcloud.passwordFile' or
                  'services.prometheus.exporters.nextcloud.tokenFile'
              '';
            }
            {
              assertion = cfg.sql.enable -> ((cfg.sql.configFile == null) != (cfg.sql.configuration == null));
              message = ''
                Please specify either 'services.prometheus.exporters.sql.configuration' or
                  'services.prometheus.exporters.sql.configFile'
              '';
            }
            {
              assertion = cfg.scaphandre.enable -> (pkgs.stdenv.targetPlatform.isx86_64 == true);
              message = ''
                Scaphandre only support x86_64 architectures.
              '';
            }
            {
              assertion =
                cfg.scaphandre.enable
                -> ((lib.kernel.whenHelpers pkgs.linux.version).whenOlder "5.11" true).condition == false;
              message = ''
                Scaphandre requires a kernel version newer than '5.11', '${pkgs.linux.version}' given.
              '';
            }
            {
              assertion = cfg.scaphandre.enable -> (builtins.elem "intel_rapl_common" config.boot.kernelModules);
              message = ''
                Scaphandre needs 'intel_rapl_common' kernel module to be enabled. Please add it in 'boot.kernelModules'.
              '';
            }
            {
              assertion =
                cfg.idrac.enable -> ((cfg.idrac.configurationPath == null) != (cfg.idrac.configuration == null));
              message = ''
                Please ensure you have either `services.prometheus.exporters.idrac.configuration'
                  or `services.prometheus.exporters.idrac.configurationPath' set!
              '';
            }
            {
              assertion =
                cfg.deluge.enable
                -> ((cfg.deluge.delugePassword == null) != (cfg.deluge.delugePasswordFile == null));
              message = ''
                Please ensure you have either `services.prometheus.exporters.deluge.delugePassword'
                  or `services.prometheus.exporters.deluge.delugePasswordFile' set!
              '';
            }
            {
              assertion =
                cfg.pgbouncer.enable
                -> (xor (cfg.pgbouncer.connectionEnvFile == null) (cfg.pgbouncer.connectionString == null));
              message = ''
                Options `services.prometheus.exporters.pgbouncer.connectionEnvFile` and
                `services.prometheus.exporters.pgbouncer.connectionString` are mutually exclusive!
              '';
            }
          ]
          ++ (flip map (attrNames exporterOpts) (exporter: {
            assertion = cfg.${exporter}.firewallFilter != null -> cfg.${exporter}.openFirewall;
            message = ''
              The `firewallFilter'-option of exporter ${exporter} doesn't have any effect unless
              `openFirewall' is set to `true'!
            '';
          }))
          ++ config.services.prometheus.exporters.assertions;
        warnings = [
          (mkIf
            (
              config.services.prometheus.exporters.idrac.enable
              && config.services.prometheus.exporters.idrac.configurationPath != null
            )
            ''
              Configuration file in `services.prometheus.exporters.idrac.configurationPath` may override
              `services.prometheus.exporters.idrac.listenAddress` and/or `services.prometheus.exporters.idrac.port`.
              Consider using `services.prometheus.exporters.idrac.configuration` instead.
            ''
          )
        ] ++ config.services.prometheus.exporters.warnings;
      }
    ]
    ++ [
      (mkIf config.services.prometheus.exporters.rtl_433.enable {
        hardware.rtl-sdr.enable = mkDefault true;
      })
    ]
    ++ [
      (mkIf config.services.postfix.enable {
        services.prometheus.exporters.postfix.group = mkDefault config.services.postfix.setgidGroup;
      })
    ]
    ++ [
      (mkIf config.services.prometheus.exporters.deluge.enable {
        system.activationScripts = {
          deluge-exported.text = ''
            mkdir -p /etc/deluge-exporter
            echo "DELUGE_PASSWORD=$(cat ${config.services.prometheus.exporters.deluge.delugePasswordFile})" > /etc/deluge-exporter/password
          '';
        };
      })
    ]
    ++ (mapAttrsToList (
      name: conf:
      mkExporterConf {
        inherit name;
        inherit (conf) serviceOpts;
        conf = cfg.${name};
      }
    ) exporterOpts)
  );

  meta = {
    doc = ./exporters.md;
    maintainers = [ ];
  };
}
