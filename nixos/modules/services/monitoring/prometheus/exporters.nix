{ config, pkgs, lib, options, utils, ... }:

let
  inherit (lib) concatStrings foldl foldl' genAttrs literalExpression maintainers
    mapAttrs mapAttrsToList mkDefault mkEnableOption mkIf mkMerge lib.mkOption
    lib.optional types lib.mkOptionDefault flip attrNames xor;

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
  #  Note that `extraOpts` is lib.optional, but a script for the exporter's
  #  systemd service must be provided by specifying either
  #  `serviceOpts.script` or `serviceOpts.serviceConfig.ExecStart`

  exporterOpts = (genAttrs [
    "apcupsd"
    "artifactory"
    "bind"
    "bird"
    "bitcoin"
    "blackbox"
    "borgmatic"
    "buildkite-agent"
    "collectd"
    "deluge"
    "dmarc"
    "dnsmasq"
    "dnssec"
    "domain"
    "dovecot"
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
    "unbound"
    "unpoller"
    "v2ray"
    "varnish"
    "wireguard"
    "zfs"
  ]
    (name:
      import (./. + "/exporters/${name}.nix") { inherit config lib pkgs options utils; }
    )) // (mapAttrs
    (name: params:
      import (./. + "/exporters/${params.name}.nix") { inherit config lib pkgs options utils; type = params.type ; })
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

  mkExporterOpts = ({ name, port }: {
    enable = lib.mkEnableOption "the prometheus ${name} exporter";
    port = lib.mkOption {
      type = lib.types.port;
      default = port;
      description = ''
        Port to listen on.
      '';
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        Address to listen on.
      '';
    };
    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Extra commandline options to pass to the ${name} exporter.
      '';
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open port in firewall for incoming connections.
      '';
    };
    firewallFilter = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = lib.literalExpression ''
        "-i eth0 -p tcp -m tcp --dport ${toString port}"
      '';
      description = ''
        Specify a filter for iptables to use when
        {option}`services.prometheus.exporters.${name}.openFirewall`
        is true. It is used as `ip46tables -I nixos-fw firewallFilter -j nixos-fw-accept`.
      '';
    };
    firewallRules = lib.mkOption {
      type = lib.types.nullOr types.lines;
      default = null;
      example = lib.literalExpression ''
        iifname "eth0" tcp dport ${toString port} counter accept
      '';
      description = ''
        Specify rules for nftables to add to the input chain
        when {option}`services.prometheus.exporters.${name}.openFirewall` is true.
      '';
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "${name}-exporter";
      description = ''
        User name under which the ${name} exporter shall be run.
      '';
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "${name}-exporter";
      description = ''
        Group under which the ${name} exporter shall be run.
      '';
    };
  });

  mkSubModule = { name, port, extraOpts, imports }: {
    ${name} = lib.mkOption {
      type = lib.types.submodule [{
        inherit imports;
        options = (mkExporterOpts {
          inherit name port;
        } // extraOpts);
      } ({ config, ... }: mkIf config.openFirewall {
        firewallFilter = lib.mkDefault "-p tcp -m tcp --dport ${toString config.port}";
        firewallRules = lib.mkDefault ''tcp dport ${toString config.port} accept comment "${name}-exporter"'';
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
      nftables = config.networking.nftables.enable;
    in
    mkIf conf.enable {
      warnings = conf.warnings or [];
      assertions = conf.assertions or [];
      users.users."${name}-exporter" = (lib.mkIf (conf.user == "${name}-exporter" && !enableDynamicUser) {
        description = "Prometheus ${name} exporter service user";
        isSystemUser = true;
        inherit (conf) group;
      });
      users.groups = lib.mkMerge [
        (lib.mkIf (conf.group == "${name}-exporter" && !enableDynamicUser) {
          "${name}-exporter" = {};
        })
        (lib.mkIf (name == "smartctl") {
          "smartctl-exporter-access" = {};
        })
      ];
      services.udev.extraRules = lib.mkIf (name == "smartctl") ''
        ACTION=="add", SUBSYSTEM=="nvme", KERNEL=="nvme[0-9]*", RUN+="${pkgs.acl}/bin/setfacl -m g:smartctl-exporter-access:rw /dev/$kernel"
      '';
      networking.firewall.extraCommands = lib.mkIf (conf.openFirewall && !nftables) (concatStrings [
        "ip46tables -A nixos-fw ${conf.firewallFilter} "
        "-m comment --comment ${name}-exporter -j nixos-fw-accept"
      ]);
      networking.firewall.extraInputRules = lib.mkIf (conf.openFirewall && nftables) conf.firewallRules;
      systemd.services."prometheus-${name}-exporter" = lib.mkMerge ([{
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.Restart = lib.mkDefault "always";
        serviceConfig.PrivateTmp = lib.mkDefault true;
        serviceConfig.WorkingDirectory = lib.mkDefault /tmp;
        serviceConfig.DynamicUser = lib.mkDefault enableDynamicUser;
        serviceConfig.User = lib.mkDefault conf.user;
        serviceConfig.Group = conf.group;
        # Hardening
        serviceConfig.CapabilityBoundingSet = lib.mkDefault [ "" ];
        serviceConfig.DeviceAllow = [ "" ];
        serviceConfig.LockPersonality = true;
        serviceConfig.MemoryDenyWriteExecute = true;
        serviceConfig.NoNewPrivileges = true;
        serviceConfig.PrivateDevices = lib.mkDefault true;
        serviceConfig.ProtectClock = lib.mkDefault true;
        serviceConfig.ProtectControlGroups = true;
        serviceConfig.ProtectHome = true;
        serviceConfig.ProtectHostname = true;
        serviceConfig.ProtectKernelLogs = true;
        serviceConfig.ProtectKernelModules = true;
        serviceConfig.ProtectKernelTunables = true;
        serviceConfig.ProtectSystem = lib.mkDefault "strict";
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

  options.services.prometheus.exporters = lib.mkOption {
    type = lib.types.submodule {
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
    default = {};
    example = lib.literalExpression ''
      {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
        varnish.enable = true;
      }
    '';
  };

  config = lib.mkMerge ([{
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
      assertion =
        cfg.restic.enable -> ((cfg.restic.repository == null) != (cfg.restic.repositoryFile == null));
      message = ''
        Please specify either 'services.prometheus.exporters.restic.repository'
          or 'services.prometheus.exporters.restic.repositoryFile'.
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
    } {
      assertion = cfg.deluge.enable -> (
        (cfg.deluge.delugePassword == null) != (cfg.deluge.delugePasswordFile == null)
      );
      message = ''
        Please ensure you have either `services.prometheus.exporters.deluge.delugePassword'
          or `services.prometheus.exporters.deluge.delugePasswordFile' set!
      '';
    } {
      assertion = cfg.pgbouncer.enable -> (
        xor (cfg.pgbouncer.connectionEnvFile == null) (cfg.pgbouncer.connectionString == null)
      );
      message = ''
        Options `services.prometheus.exporters.pgbouncer.connectionEnvFile` and
        `services.prometheus.exporters.pgbouncer.connectionString` are mutually exclusive!
      '';
    }] ++ (flip map (attrNames exporterOpts) (exporter: {
      assertion = cfg.${exporter}.firewallFilter != null -> cfg.${exporter}.openFirewall;
      message = ''
        The `firewallFilter'-option of exporter ${exporter} doesn't have any effect unless
        `openFirewall' is set to `true'!
      '';
    })) ++ config.services.prometheus.exporters.assertions;
    warnings = [
      (lib.mkIf (config.services.prometheus.exporters.idrac.enable && config.services.prometheus.exporters.idrac.configurationPath != null) ''
          Configuration file in `services.prometheus.exporters.idrac.configurationPath` may override
          `services.prometheus.exporters.idrac.listenAddress` and/or `services.prometheus.exporters.idrac.port`.
          Consider using `services.prometheus.exporters.idrac.configuration` instead.
        ''
      )
    ] ++ config.services.prometheus.exporters.warnings;
  }]  ++ [(lib.mkIf config.services.prometheus.exporters.rtl_433.enable {
    hardware.rtl-sdr.enable = lib.mkDefault true;
  })] ++ [(lib.mkIf config.services.postfix.enable {
    services.prometheus.exporters.postfix.group = lib.mkDefault config.services.postfix.setgidGroup;
  })] ++ [(lib.mkIf config.services.prometheus.exporters.deluge.enable {
    system.activationScripts = {
      deluge-exported.text = ''
      mkdir -p /etc/deluge-exporter
      echo "DELUGE_PASSWORD=$(cat ${config.services.prometheus.exporters.deluge.delugePasswordFile})" > /etc/deluge-exporter/password
      '';
    };
  })] ++ (mapAttrsToList (name: conf:
    mkExporterConf {
      inherit name;
      inherit (conf) serviceOpts;
      conf = cfg.${name};
    }) exporterOpts)
  );

  meta = {
    doc = ./exporters.md;
    maintainers = [ lib.maintainers.willibutz ];
  };
}
