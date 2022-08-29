{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.trafficserver;
  user = config.users.users.trafficserver.name;
  group = config.users.groups.trafficserver.name;

  getManualUrl = name: "https://docs.trafficserver.apache.org/en/latest/admin-guide/files/${name}.en.html";

  yaml = pkgs.formats.yaml { };

  mkYamlConf = name: cfg:
    if cfg != null then {
      "trafficserver/${name}.yaml".source = yaml.generate "${name}.yaml" cfg;
    } else {
      "trafficserver/${name}.yaml".text = "";
    };

  mkRecordLines = path: value:
    if isAttrs value then
      lib.mapAttrsToList (n: v: mkRecordLines (path ++ [ n ]) v) value
    else if isInt value then
      "CONFIG ${concatStringsSep "." path} INT ${toString value}"
    else if isFloat value then
      "CONFIG ${concatStringsSep "." path} FLOAT ${toString value}"
    else
      "CONFIG ${concatStringsSep "." path} STRING ${toString value}";

  mkRecordsConfig = cfg: concatStringsSep "\n" (flatten (mkRecordLines [ ] cfg));
  mkPluginConfig = cfg: concatStringsSep "\n" (map (p: "${p.path} ${p.arg}") cfg);
in
{
  options.services.trafficserver = {
    enable = mkEnableOption "Apache Traffic Server";

    cache = mkOption {
      type = types.lines;
      default = "";
      example = "dest_domain=example.com suffix=js action=never-cache";
      description = lib.mdDoc ''
        Caching rules that overrule the origin's caching policy.

        Consult the [upstream
        documentation](${getManualUrl "cache.config"}) for more details.
      '';
    };

    hosting = mkOption {
      type = types.lines;
      default = "";
      example = "domain=example.com volume=1";
      description = lib.mdDoc ''
        Partition the cache according to origin server or domain

        Consult the [
        upstream documentation](${getManualUrl "hosting.config"}) for more details.
      '';
    };

    ipAllow = mkOption {
      type = types.nullOr yaml.type;
      default = lib.importJSON ./ip_allow.json;
      defaultText = literalMD "upstream defaults";
      example = literalExpression ''
        {
          ip_allow = [{
            apply = "in";
            ip_addrs = "127.0.0.1";
            action = "allow";
            methods = "ALL";
          }];
        }
      '';
      description = lib.mdDoc ''
        Control client access to Traffic Server and Traffic Server connections
        to upstream servers.

        Consult the [upstream
        documentation](${getManualUrl "ip_allow.yaml"}) for more details.
      '';
    };

    logging = mkOption {
      type = types.nullOr yaml.type;
      default = lib.importJSON ./logging.json;
      defaultText = literalMD "upstream defaults";
      example = { };
      description = lib.mdDoc ''
        Configure logs.

        Consult the [upstream
        documentation](${getManualUrl "logging.yaml"}) for more details.
      '';
    };

    parent = mkOption {
      type = types.lines;
      default = "";
      example = ''
        dest_domain=. method=get parent="p1.example:8080; p2.example:8080" round_robin=true
      '';
      description = lib.mdDoc ''
        Identify the parent proxies used in an cache hierarchy.

        Consult the [upstream
        documentation](${getManualUrl "parent.config"}) for more details.
      '';
    };

    plugins = mkOption {
      default = [ ];

      description = lib.mdDoc ''
        Controls run-time loadable plugins available to Traffic Server, as
        well as their configuration.

        Consult the [upstream
        documentation](${getManualUrl "plugin.config"}) for more details.
      '';

      type = with types;
        listOf (submodule {
          options.path = mkOption {
            type = str;
            example = "xdebug.so";
            description = lib.mdDoc ''
              Path to plugin. The path can either be absolute, or relative to
              the plugin directory.
            '';
          };
          options.arg = mkOption {
            type = str;
            default = "";
            example = "--header=ATS-My-Debug";
            description = lib.mdDoc "arguments to pass to the plugin";
          };
        });
    };

    records = mkOption {
      type = with types;
        let valueType = (attrsOf (oneOf [ int float str valueType ])) // {
          description = "Traffic Server records value";
        };
        in
        valueType;
      default = { };
      example = { proxy.config.proxy_name = "my_server"; };
      description = lib.mdDoc ''
        List of configurable variables used by Traffic Server.

        Consult the [
        upstream documentation](${getManualUrl "records.config"}) for more details.
      '';
    };

    remap = mkOption {
      type = types.lines;
      default = "";
      example = "map http://from.example http://origin.example";
      description = lib.mdDoc ''
        URL remapping rules used by Traffic Server.

        Consult the [
        upstream documentation](${getManualUrl "remap.config"}) for more details.
      '';
    };

    splitDns = mkOption {
      type = types.lines;
      default = "";
      example = ''
        dest_domain=internal.corp.example named="255.255.255.255:212 255.255.255.254" def_domain=corp.example search_list="corp.example corp1.example"
        dest_domain=!internal.corp.example named=255.255.255.253
      '';
      description = lib.mdDoc ''
        Specify the DNS server that Traffic Server should use under specific
        conditions.

        Consult the [
        upstream documentation](${getManualUrl "splitdns.config"}) for more details.
      '';
    };

    sslMulticert = mkOption {
      type = types.lines;
      default = "";
      example = "dest_ip=* ssl_cert_name=default.pem";
      description = lib.mdDoc ''
        Configure SSL server certificates to terminate the SSL sessions.

        Consult the [
        upstream documentation](${getManualUrl "ssl_multicert.config"}) for more details.
      '';
    };

    sni = mkOption {
      type = types.nullOr yaml.type;
      default = null;
      example = literalExpression ''
        {
          sni = [{
            fqdn = "no-http2.example.com";
            https = "off";
          }];
        }
      '';
      description = lib.mdDoc ''
        Configure aspects of TLS connection handling for both inbound and
        outbound connections.

        Consult the [upstream
        documentation](${getManualUrl "sni.yaml"}) for more details.
      '';
    };

    storage = mkOption {
      type = types.lines;
      default = "/var/cache/trafficserver 256M";
      example = "/dev/disk/by-id/XXXXX volume=1";
      description = lib.mdDoc ''
        List all the storage that make up the Traffic Server cache.

        Consult the [
        upstream documentation](${getManualUrl "storage.config"}) for more details.
      '';
    };

    strategies = mkOption {
      type = types.nullOr yaml.type;
      default = null;
      description = lib.mdDoc ''
        Specify the next hop proxies used in an cache hierarchy and the
        algorithms used to select the next proxy.

        Consult the [
        upstream documentation](${getManualUrl "strategies.yaml"}) for more details.
      '';
    };

    volume = mkOption {
      type = types.nullOr yaml.type;
      default = "";
      example = "volume=1 scheme=http size=20%";
      description = lib.mdDoc ''
        Manage cache space more efficiently and restrict disk usage by
        creating cache volumes of different sizes.

        Consult the [
        upstream documentation](${getManualUrl "volume.config"}) for more details.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "trafficserver/cache.config".text = cfg.cache;
      "trafficserver/hosting.config".text = cfg.hosting;
      "trafficserver/parent.config".text = cfg.parent;
      "trafficserver/plugin.config".text = mkPluginConfig cfg.plugins;
      "trafficserver/records.config".text = mkRecordsConfig cfg.records;
      "trafficserver/remap.config".text = cfg.remap;
      "trafficserver/splitdns.config".text = cfg.splitDns;
      "trafficserver/ssl_multicert.config".text = cfg.sslMulticert;
      "trafficserver/storage.config".text = cfg.storage;
      "trafficserver/volume.config".text = cfg.volume;
    } // (mkYamlConf "ip_allow" cfg.ipAllow)
    // (mkYamlConf "logging" cfg.logging)
    // (mkYamlConf "sni" cfg.sni)
    // (mkYamlConf "strategies" cfg.strategies);

    environment.systemPackages = [ pkgs.trafficserver ];
    systemd.packages = [ pkgs.trafficserver ];

    # Traffic Server does privilege handling independently of systemd, and
    # therefore should be started as root
    systemd.services.trafficserver = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
    };

    # These directories can't be created by systemd because:
    #
    #   1. Traffic Servers starts as root and switches to an unprivileged user
    #      afterwards. The runtime directories defined below are assumed to be
    #      owned by that user.
    #   2. The bin/trafficserver script assumes these directories exist.
    systemd.tmpfiles.rules = [
      "d '/run/trafficserver' - ${user} ${group} - -"
      "d '/var/cache/trafficserver' - ${user} ${group} - -"
      "d '/var/lib/trafficserver' - ${user} ${group} - -"
      "d '/var/log/trafficserver' - ${user} ${group} - -"
    ];

    services.trafficserver = {
      records.proxy.config.admin.user_id = user;
      records.proxy.config.body_factory.template_sets_dir =
        "${pkgs.trafficserver}/etc/trafficserver/body_factory";
    };

    users.users.trafficserver = {
      description = "Apache Traffic Server";
      isSystemUser = true;
      inherit group;
    };
    users.groups.trafficserver = { };
  };
}
