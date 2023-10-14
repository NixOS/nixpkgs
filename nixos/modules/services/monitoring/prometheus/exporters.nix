{ config, pkgs, lib, options, ... }:

let
  inherit (lib) concatStrings foldl foldl' genAttrs literalExpression maintainers
                mapAttrsToList mkDefault mkEnableOption mkIf mkMerge mkOption
                optional types mkOptionDefault flip attrNames;

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

  exporterOpts = genAttrs [
    "apcupsd"
    "artifactory"
    "bind"
    "bird"
    "bitcoin"
    "blackbox"
    "buildkite-agent"
    "collectd"
    "dmarc"
    "dnsmasq"
    "domain"
    "dovecot"
    "fastly"
    "fritzbox"
    "graphite"
    "idrac"
    "imap-mailstat"
    "influxdb"
    "ipmi"
    "json"
    "jitsi"
    "junos-czerwonk"
    "kea"
    "keylight"
    "knot"
    "lnd"
    "mail"
    "mikrotik"
    "minio"
    "modemmanager"
    "mysqld"
    "nextcloud"
    "nginx"
    "nginxlog"
    "node"
    "nut"
    "openldap"
    "openvpn"
    "pgbouncer"
    "php-fpm"
    "pihole"
    "postfix"
    "postgres"
    "process"
    "pve"
    "py-air-control"
    "redis"
    "rspamd"
    "rtl_433"
    "sabnzbd"
    "scaphandre"
    "script"
    "shelly"
    "snmp"
    "smartctl"
    "smokeping"
    "sql"
    "statsd"
    "surfboard"
    "systemd"
    "tor"
    "unbound"
    "unifi"
    "unpoller"
    "v2ray"
    "varnish"
    "wireguard"
    "flow"
    "zfs"
  ] (name:
    import (./. + "/exporters/${name}.nix") { inherit config lib pkgs options; }
  );

  mkExporterOpts = ({ name, port }: {
    enable = mkEnableOption (lib.mdDoc "the prometheus ${name} exporter");
    port = mkOption {
      type = types.port;
      default = port;
      description = lib.mdDoc ''
        Port to listen on.
      '';
    };
    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = lib.mdDoc ''
        Address to listen on.
      '';
    };
    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra commandline options to pass to the ${name} exporter.
      '';
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open port in firewall for incoming connections.
      '';
    };
    firewallFilter = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = literalExpression ''
        "-i eth0 -p tcp -m tcp --dport ${toString port}"
      '';
      description = lib.mdDoc ''
        Specify a filter for iptables to use when
        {option}`services.prometheus.exporters.${name}.openFirewall`
        is true. It is used as `ip46tables -I nixos-fw firewallFilter -j nixos-fw-accept`.
      '';
    };
    user = mkOption {
      type = types.str;
      default = "${name}-exporter";
      description = lib.mdDoc ''
        User name under which the ${name} exporter shall be run.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "${name}-exporter";
      description = lib.mdDoc ''
        Group under which the ${name} exporter shall be run.
      '';
    };
  });

  mkSubModule = { name, port, extraOpts, imports }: {
    ${name} = mkOption {
      type = types.submodule [{
        inherit imports;
        options = (mkExporterOpts {
          inherit name port;
        } // extraOpts);
      } ({ config, ... }: mkIf config.openFirewall {
        firewallFilter = mkDefault "-p tcp -m tcp --dport ${toString config.port}";
      })];
      internal = true;
      default = {};
    };
  };

  mkSubModules = (foldl' (a: b: a//b) {}
    (mapAttrsToList (name: opts: mkSubModule {
      inherit name;
      inherit (opts) port;
      extraOpts = opts.extraOpts or {};
      imports = opts.imports or [];
    }) exporterOpts)
  );

  mkExporterConf = { name, conf, serviceOpts }:
    let
      enableDynamicUser = serviceOpts.serviceConfig.DynamicUser or true;
    in
    mkIf conf.enable {
      warnings = conf.warnings or [];
      users.users."${name}-exporter" = (mkIf (conf.user == "${name}-exporter" && !enableDynamicUser) {
        description = "Prometheus ${name} exporter service user";
        isSystemUser = true;
        inherit (conf) group;
      });
      users.groups = (mkIf (conf.group == "${name}-exporter" && !enableDynamicUser) {
        "${name}-exporter" = {};
      });
      networking.firewall.extraCommands = mkIf conf.openFirewall (concatStrings [
        "ip46tables -A nixos-fw ${conf.firewallFilter} "
        "-m comment --comment ${name}-exporter -j nixos-fw-accept"
      ]);
      systemd.services."prometheus-${name}-exporter" = mkMerge ([{
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.Restart = mkDefault "always";
        serviceConfig.PrivateTmp = mkDefault true;
        serviceConfig.WorkingDirectory = mkDefault /tmp;
        serviceConfig.DynamicUser = mkDefault enableDynamicUser;
        serviceConfig.User = mkDefault conf.user;
        serviceConfig.Group = conf.group;
        # Hardening
        serviceConfig.CapabilityBoundingSet = mkDefault [ "" ];
        serviceConfig.DeviceAllow = [ "" ];
        serviceConfig.LockPersonality = true;
        serviceConfig.MemoryDenyWriteExecute = true;
        serviceConfig.NoNewPrivileges = true;
        serviceConfig.PrivateDevices = mkDefault true;
        serviceConfig.ProtectClock = mkDefault true;
        serviceConfig.ProtectControlGroups = true;
        serviceConfig.ProtectHome = true;
        serviceConfig.ProtectHostname = true;
        serviceConfig.ProtectKernelLogs = true;
        serviceConfig.ProtectKernelModules = true;
        serviceConfig.ProtectKernelTunables = true;
        serviceConfig.ProtectSystem = mkDefault "strict";
        serviceConfig.RemoveIPC = true;
        serviceConfig.RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        serviceConfig.RestrictNamespaces = true;
        serviceConfig.RestrictRealtime = true;
        serviceConfig.RestrictSUIDSGID = true;
        serviceConfig.SystemCallArchitectures = "native";
        serviceConfig.UMask = "0077";
      } serviceOpts ]);
  };
in
{

  imports = (lib.forEach [ "blackboxExporter" "collectdExporter" "fritzboxExporter"
                   "jsonExporter" "minioExporter" "nginxExporter" "nodeExporter"
                   "snmpExporter" "unifiExporter" "varnishExporter" ]
       (opt: lib.mkRemovedOptionModule [ "services" "prometheus" "${opt}" ] ''
         The prometheus exporters are now configured using `services.prometheus.exporters'.
         See the 18.03 release notes for more information.
       '' ));

  options.services.prometheus.exporters = mkOption {
    type = types.submodule {
      options = (mkSubModules);
      imports = [
        ../../../misc/assertions.nix
        (lib.mkRenamedOptionModule [ "unifi-poller" ] [ "unpoller" ])
      ];
    };
    description = lib.mdDoc "Prometheus exporter configuration";
    default = {};
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

  config = mkMerge ([{
    assertions = [ {
      assertion = cfg.ipmi.enable -> (cfg.ipmi.configFile != null) -> (
        !(lib.hasPrefix "/tmp/" cfg.ipmi.configFile)
      );
      message = ''
        Config file specified in `services.prometheus.exporters.ipmi.configFile' must
          not reside within /tmp - it won't be visible to the systemd service.
      '';
    } {
      assertion = cfg.ipmi.enable -> (cfg.ipmi.webConfigFile != null) -> (
        !(lib.hasPrefix "/tmp/" cfg.ipmi.webConfigFile)
      );
      message = ''
        Config file specified in `services.prometheus.exporters.ipmi.webConfigFile' must
          not reside within /tmp - it won't be visible to the systemd service.
      '';
    } {
      assertion = cfg.snmp.enable -> (
        (cfg.snmp.configurationPath == null) != (cfg.snmp.configuration == null)
      );
      message = ''
        Please ensure you have either `services.prometheus.exporters.snmp.configuration'
          or `services.prometheus.exporters.snmp.configurationPath' set!
      '';
    } {
      assertion = cfg.mikrotik.enable -> (
        (cfg.mikrotik.configFile == null) != (cfg.mikrotik.configuration == null)
      );
      message = ''
        Please specify either `services.prometheus.exporters.mikrotik.configuration'
          or `services.prometheus.exporters.mikrotik.configFile'.
      '';
    } {
      assertion = cfg.mail.enable -> (
        (cfg.mail.configFile == null) != (cfg.mail.configuration == null)
      );
      message = ''
        Please specify either 'services.prometheus.exporters.mail.configuration'
          or 'services.prometheus.exporters.mail.configFile'.
      '';
    } {
      assertion = cfg.mysqld.runAsLocalSuperUser -> config.services.mysql.enable;
      message = ''
        The exporter is configured to run as 'services.mysql.user', but
          'services.mysql.enable' is set to false.
      '';
    } {
      assertion = cfg.nextcloud.enable -> (
        (cfg.nextcloud.passwordFile == null) != (cfg.nextcloud.tokenFile == null)
      );
      message = ''
        Please specify either 'services.prometheus.exporters.nextcloud.passwordFile' or
          'services.prometheus.exporters.nextcloud.tokenFile'
      '';
    } {
      assertion =  cfg.pgbouncer.enable -> (
        (cfg.pgbouncer.connectionStringFile != null || cfg.pgbouncer.connectionString != "")
      );
        message = ''
          PgBouncer exporter needs either connectionStringFile or connectionString configured"
        '';
    } {
      assertion = cfg.pgbouncer.enable -> (
        config.services.pgbouncer.ignoreStartupParameters != null && builtins.match ".*extra_float_digits.*" config.services.pgbouncer.ignoreStartupParameters != null
        );
        message = ''
          Prometheus PgBouncer exporter requires including `extra_float_digits` in services.pgbouncer.ignoreStartupParameters

          Example:
          services.pgbouncer.ignoreStartupParameters = extra_float_digits;

          See https://github.com/prometheus-community/pgbouncer_exporter#pgbouncer-configuration
        '';
    } {
      assertion = cfg.sql.enable -> (
        (cfg.sql.configFile == null) != (cfg.sql.configuration == null)
      );
      message = ''
        Please specify either 'services.prometheus.exporters.sql.configuration' or
          'services.prometheus.exporters.sql.configFile'
      '';
    } {
      assertion = cfg.scaphandre.enable -> (pkgs.stdenv.targetPlatform.isx86_64 == true);
      message = ''
        Scaphandre only support x86_64 architectures.
      '';
    } {
      assertion = cfg.scaphandre.enable -> ((lib.kernel.whenHelpers pkgs.linux.version).whenOlder "5.11" true).condition == false;
      message = ''
        Scaphandre requires a kernel version newer than '5.11', '${pkgs.linux.version}' given.
      '';
    } {
      assertion = cfg.scaphandre.enable -> (builtins.elem "intel_rapl_common" config.boot.kernelModules);
      message = ''
        Scaphandre needs 'intel_rapl_common' kernel module to be enabled. Please add it in 'boot.kernelModules'.
      '';
    } {
      assertion = cfg.idrac.enable -> (
        (cfg.idrac.configurationPath == null) != (cfg.idrac.configuration == null)
      );
      message = ''
        Please ensure you have either `services.prometheus.exporters.idrac.configuration'
          or `services.prometheus.exporters.idrac.configurationPath' set!
      '';
    } ] ++ (flip map (attrNames exporterOpts) (exporter: {
      assertion = cfg.${exporter}.firewallFilter != null -> cfg.${exporter}.openFirewall;
      message = ''
        The `firewallFilter'-option of exporter ${exporter} doesn't have any effect unless
        `openFirewall' is set to `true'!
      '';
    })) ++ config.services.prometheus.exporters.assertions;
    warnings = [
      (mkIf (config.services.prometheus.exporters.idrac.enable && config.services.prometheus.exporters.idrac.configurationPath != null) ''
          Configuration file in `services.prometheus.exporters.idrac.configurationPath` may override
          `services.prometheus.exporters.idrac.listenAddress` and/or `services.prometheus.exporters.idrac.port`.
          Consider using `services.prometheus.exporters.idrac.configuration` instead.
        ''
      )
      (mkIf
        (cfg.pgbouncer.enable && cfg.pgbouncer.connectionString != "") ''
          config.services.prometheus.exporters.pgbouncer.connectionString is insecure. Use connectionStringFile instead.
        ''
      )
      (mkIf
        (cfg.pgbouncer.enable && config.services.pgbouncer.authType != "any") ''
          Admin user (with password or passwordless) MUST exist in the services.pgbouncer.authFile if authType other than any is used.
        ''
      )
    ] ++ config.services.prometheus.exporters.warnings;
  }] ++ [(mkIf config.services.minio.enable {
    services.prometheus.exporters.minio.minioAddress  = mkDefault "http://localhost:9000";
    services.prometheus.exporters.minio.minioAccessKey = mkDefault config.services.minio.accessKey;
    services.prometheus.exporters.minio.minioAccessSecret = mkDefault config.services.minio.secretKey;
  })] ++ [(mkIf config.services.prometheus.exporters.rtl_433.enable {
    hardware.rtl-sdr.enable = mkDefault true;
  })] ++ [(mkIf config.services.postfix.enable {
    services.prometheus.exporters.postfix.group = mkDefault config.services.postfix.setgidGroup;
  })] ++ (mapAttrsToList (name: conf:
    mkExporterConf {
      inherit name;
      inherit (conf) serviceOpts;
      conf = cfg.${name};
    }) exporterOpts)
  );

  meta = {
    doc = ./exporters.md;
    maintainers = [ maintainers.willibutz ];
  };
}
