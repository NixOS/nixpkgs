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
    "influxdb"
    "json"
    "jitsi"
    "kea"
    "keylight"
    "knot"
    "lnd"
    "mail"
    "mikrotik"
    "minio"
    "modemmanager"
    "nextcloud"
    "nginx"
    "nginxlog"
    "node"
    "openldap"
    "openvpn"
    "pihole"
    "postfix"
    "postgres"
    "process"
    "pve"
    "py-air-control"
    "redis"
    "rspamd"
    "rtl_433"
    "script"
    "snmp"
    "smartctl"
    "smokeping"
    "sql"
    "surfboard"
    "systemd"
    "tor"
    "unbound"
    "unifi"
    "unifi-poller"
    "varnish"
    "wireguard"
    "flow"
  ] (name:
    import (./. + "/exporters/${name}.nix") { inherit config lib pkgs options; }
  );

  mkExporterOpts = ({ name, port }: {
    enable = mkEnableOption "the prometheus ${name} exporter";
    port = mkOption {
      type = types.port;
      default = port;
      description = ''
        Port to listen on.
      '';
    };
    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Address to listen on.
      '';
    };
    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra commandline options to pass to the ${name} exporter.
      '';
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open port in firewall for incoming connections.
      '';
    };
    firewallFilter = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = literalExpression ''
        "-i eth0 -p tcp -m tcp --dport ${toString port}"
      '';
      description = ''
        Specify a filter for iptables to use when
        <option>services.prometheus.exporters.${name}.openFirewall</option>
        is true. It is used as `ip46tables -I nixos-fw <option>firewallFilter</option> -j nixos-fw-accept`.
      '';
    };
    user = mkOption {
      type = types.str;
      default = "${name}-exporter";
      description = ''
        User name under which the ${name} exporter shall be run.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "${name}-exporter";
      description = ''
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
        serviceConfig.PrivateDevices = true;
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
    };
    description = "Prometheus exporter configuration";
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
      assertion = cfg.sql.enable -> (
        (cfg.sql.configFile == null) != (cfg.sql.configuration == null)
      );
      message = ''
        Please specify either 'services.prometheus.exporters.sql.configuration' or
          'services.prometheus.exporters.sql.configFile'
      '';
    } ] ++ (flip map (attrNames cfg) (exporter: {
      assertion = cfg.${exporter}.firewallFilter != null -> cfg.${exporter}.openFirewall;
      message = ''
        The `firewallFilter'-option of exporter ${exporter} doesn't have any effect unless
        `openFirewall' is set to `true'!
      '';
    }));
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
    doc = ./exporters.xml;
    maintainers = [ maintainers.willibutz ];
  };
}
