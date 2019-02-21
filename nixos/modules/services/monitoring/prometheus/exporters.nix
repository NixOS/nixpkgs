{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters;
  cfg2 = config.services.prometheus2.exporters;

  # each attribute in `exporterOpts` is a function that when executed
  # with `cfg` or `cfg2` as parameter is expected to have specified:
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
  exporterOpts = {
    blackbox  = import ./exporters/blackbox.nix  { inherit config lib pkgs; };
    collectd  = import ./exporters/collectd.nix  { inherit config lib pkgs; };
    dnsmasq   = import ./exporters/dnsmasq.nix   { inherit config lib pkgs; };
    dovecot   = import ./exporters/dovecot.nix   { inherit config lib pkgs; };
    fritzbox  = import ./exporters/fritzbox.nix  { inherit config lib pkgs; };
    json      = import ./exporters/json.nix      { inherit config lib pkgs; };
    minio     = import ./exporters/minio.nix     { inherit config lib pkgs; };
    nginx     = import ./exporters/nginx.nix     { inherit config lib pkgs; };
    node      = import ./exporters/node.nix      { inherit config lib pkgs; };
    postfix   = import ./exporters/postfix.nix   { inherit config lib pkgs; };
    snmp      = import ./exporters/snmp.nix      { inherit config lib pkgs; };
    surfboard = import ./exporters/surfboard.nix { inherit config lib pkgs; };
    tor       = import ./exporters/tor.nix       { inherit config lib pkgs; };
    unifi     = import ./exporters/unifi.nix     { inherit config lib pkgs; };
    varnish   = import ./exporters/varnish.nix   { inherit config lib pkgs; };
    bind      = import ./exporters/bind.nix      { inherit config lib pkgs; };
  };

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
      default = "nobody";
      description = ''
        User name under which the ${name} exporter shall be run.
        Has no effect when <option>systemd.services.prometheus-${name}-exporter.serviceConfig.DynamicUser</option> is true.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "nobody";
      description = ''
        Group under which the ${name} exporter shall be run.
        Has no effect when <option>systemd.services.prometheus-${name}-exporter.serviceConfig.DynamicUser</option> is true.
      '';
    };
  });

  mkSubModule = { name, port, extraOpts, ... }: {
    ${name} = mkOption {
      type = types.submodule {
        options = (mkExporterOpts {
          inherit name port;
        } // extraOpts);
      };
      internal = true;
      default = {};
    };
  };

  mkSubModules = exCfg:
    (foldl' (a: b: a//b) {}
      (mapAttrsToList (name: confGen:
        let
          conf = (confGen exCfg);
        in
          mkSubModule {
            inherit name;
            inherit (conf) port serviceOpts;
            extraOpts = conf.extraOpts or {};
          }) exporterOpts)
    );

  mkExporterConf = { name, conf, serviceOpts }:
    mkIf conf.enable {
      networking.firewall.extraCommands = mkIf conf.openFirewall (concatStrings [
        "ip46tables -I nixos-fw ${conf.firewallFilter} "
        "-m comment --comment ${name}-exporter -j nixos-fw-accept"
      ]);
      systemd.services."prometheus-${name}-exporter" = mkMerge ([{
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.Restart = mkDefault "always";
        serviceConfig.PrivateTmp = mkDefault true;
        serviceConfig.WorkingDirectory = mkDefault /tmp;
      } serviceOpts ] ++ optional (!(serviceOpts.serviceConfig.DynamicUser or false)) {
        serviceConfig.User = conf.user;
        serviceConfig.Group = conf.group;
      });
  };
  mkExportersConfig = exCfg: promVersion:
    ([{
      assertions = [{
        assertion = (exCfg.snmp.configurationPath == null) != (exCfg.snmp.configuration == null);
        message = ''
          Please ensure you have either `services.prometheus.exporters.snmp.configuration'
          or `services.prometheus${promVersion}.exporters.snmp.configurationPath' set!
        '';
      }];
    }] ++ [(mkIf config.services.minio.enable {
      services."prometheus${promVersion}".exporters.minio = {
        minioAddress  = mkDefault "http://localhost:9000";
        minioAccessKey = mkDefault config.services.minio.accessKey;
        minioAccessSecret = mkDefault config.services.minio.secretKey;
      };
    })] ++ (mapAttrsToList (name: confGen:
      let
        conf = (confGen exCfg);
      in
      mkExporterConf {
        inherit name;
        inherit (conf) serviceOpts;
        conf = exCfg.${name};
      }) exporterOpts)
    );
in
{
  options.services.prometheus.exporters = mkOption {
    type = types.submodule {
      options = (mkSubModules cfg);
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

  options.services.prometheus2.exporters = mkOption {
    type = types.submodule {
      options = (mkSubModules cfg2);
    };
    description = "Prometheus 2 exporter configuration";
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

  config = mkMerge ((mkExportersConfig cfg "") ++ (mkExportersConfig cfg2 "2"));

  meta = {
    doc = ./exporters.xml;
    maintainers = [ maintainers.willibutz ];
  };
}
