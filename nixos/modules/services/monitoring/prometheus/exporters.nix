{ config, pkgs, lib, options, ... }:

let
  inherit (lib) concatStrings foldl foldl' genAttrs literalExample maintainers
                mapAttrsToList mkDefault mkEnableOption mkIf mkMerge mkOption
                optional types;

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
    "bind"
    "blackbox"
    "collectd"
    "dnsmasq"
    "dovecot"
    "fritzbox"
    "json"
    "mail"
    "minio"
    "nextcloud"
    "nginx"
    "node"
    "postfix"
    "postgres"
    "rspamd"
    "snmp"
    "surfboard"
    "tor"
    "unifi"
    "varnish"
    "wireguard"
  ] (name:
    import (./. + "/exporters/${name}.nix") { inherit config lib pkgs options; }
  );

  mkExporterOpts = ({ name, port }: {
    enable = mkEnableOption "the prometheus ${name} exporter";
    port = mkOption {
      type = types.int;
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
      type = types.str;
      default = "-p tcp -m tcp --dport ${toString port}";
      example = literalExample ''
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
        Has no effect when <option>systemd.services.prometheus-${name}-exporter.serviceConfig.DynamicUser</option> is true.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "${name}-exporter";
      description = ''
        Group under which the ${name} exporter shall be run.
        Has no effect when <option>systemd.services.prometheus-${name}-exporter.serviceConfig.DynamicUser</option> is true.
      '';
    };
  });

  mkSubModule = { name, port, extraOpts, imports }: {
    ${name} = mkOption {
      type = types.submodule {
        inherit imports;
        options = (mkExporterOpts {
          inherit name port;
        } // extraOpts);
      };
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
      } serviceOpts ] ++ optional (!enableDynamicUser) {
        serviceConfig.User = conf.user;
        serviceConfig.Group = conf.group;
      });
  };
in
{

  imports = (lib.forEach [ "blackboxExporter" "collectdExporter" "fritzboxExporter"
                   "jsonExporter" "minioExporter" "nginxExporter" "nodeExporter"
                   "snmpExporter" "unifiExporter" "varnishExporter" ]
       (opt: lib.mkRemovedOptionModule [ "services" "prometheus" "${opt}" ] ''
         The prometheus exporters are now configured using `services.prometheus.exporters'.
         See the 18.03 release notes for more information.
       '' ))

    ++ (lib.forEach [ "enable" "substitutions" "preset" ]
       (opt: lib.mkRemovedOptionModule [ "fonts" "fontconfig" "ultimate" "${opt}" ] ''
         The fonts.fontconfig.ultimate module and configuration is obsolete.
         The repository has since been archived and activity has ceased.
         https://github.com/bohoomil/fontconfig-ultimate/issues/171.
         No action should be needed for font configuration, as the fonts.fontconfig
         module is already used by default.
       '' ));

  options.services.prometheus.exporters = mkOption {
    type = types.submodule {
      options = (mkSubModules);
    };
    description = "Prometheus exporter configuration";
    default = {};
    example = literalExample ''
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
      assertion = (cfg.snmp.configurationPath == null) != (cfg.snmp.configuration == null);
      message = ''
        Please ensure you have either `services.prometheus.exporters.snmp.configuration'
          or `services.prometheus.exporters.snmp.configurationPath' set!
      '';
    } {
      assertion = (cfg.mail.configFile == null) != (cfg.mail.configuration == {});
      message = ''
        Please specify either 'services.prometheus.exporters.mail.configuration'
          or 'services.prometheus.exporters.mail.configFile'.
      '';
    } ];
  }] ++ [(mkIf config.services.minio.enable {
    services.prometheus.exporters.minio.minioAddress  = mkDefault "http://localhost:9000";
    services.prometheus.exporters.minio.minioAccessKey = mkDefault config.services.minio.accessKey;
    services.prometheus.exporters.minio.minioAccessSecret = mkDefault config.services.minio.secretKey;
  })] ++ [(mkIf config.services.rspamd.enable {
    services.prometheus.exporters.rspamd.url = mkDefault "http://localhost:11334/stat";
  })] ++ [(mkIf config.services.nginx.enable {
    systemd.services.prometheus-nginx-exporter.after = [ "nginx.service" ];
    systemd.services.prometheus-nginx-exporter.requires = [ "nginx.service" ];
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
