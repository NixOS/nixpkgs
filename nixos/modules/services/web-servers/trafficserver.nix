{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.trafficserver;
  user = config.users.users.trafficserver.name;
  group = config.users.groups.trafficserver.name;

  getManualUrl = name: "https://docs.trafficserver.apache.org/en/latest/admin-guide/files/${name}.en.html";
  getConfPath = name: "${pkgs.trafficserver}/etc/trafficserver/${name}";

  yaml = pkgs.formats.yaml { };

  fromYAML = f:
    let
      jsonFile = pkgs.runCommand "in.json"
        {
          nativeBuildInputs = [ pkgs.remarshal ];
        } ''
        yaml2json < "${f}" > "$out"
      '';
    in
    builtins.fromJSON (builtins.readFile jsonFile);

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
      description = ''
        Caching rules that overrule the origin's caching policy.

        Consult the <link xlink:href="${getManualUrl "cache.config"}">upstream
        documentation</link> for more details.
      '';
    };

    hosting = mkOption {
      type = types.lines;
      default = "";
      example = "domain=example.com volume=1";
      description = ''
        Partition the cache according to origin server or domain

        Consult the <link xlink:href="${getManualUrl "hosting.config"}">
        upstream documentation</link> for more details.
      '';
    };

    ipAllow = mkOption {
      type = types.nullOr yaml.type;
      default = fromYAML (getConfPath "ip_allow.yaml");
      defaultText = "upstream defaults";
      example = literalExample {
        ip_allow = [{
          apply = "in";
          ip_addrs = "127.0.0.1";
          action = "allow";
          methods = "ALL";
        }];
      };
      description = ''
        Control client access to Traffic Server and Traffic Server connections
        to upstream servers.

        Consult the <link xlink:href="${getManualUrl "ip_allow.yaml"}">upstream
        documentation</link> for more details.
      '';
    };

    logging = mkOption {
      type = types.nullOr yaml.type;
      default = fromYAML (getConfPath "logging.yaml");
      defaultText = "upstream defaults";
      example = literalExample { };
      description = ''
        Configure logs.

        Consult the <link xlink:href="${getManualUrl "logging.yaml"}">upstream
        documentation</link> for more details.
      '';
    };

    parent = mkOption {
      type = types.lines;
      default = "";
      example = ''
        dest_domain=. method=get parent="p1.example:8080; p2.example:8080" round_robin=true
      '';
      description = ''
        Identify the parent proxies used in an cache hierarchy.

        Consult the <link xlink:href="${getManualUrl "parent.config"}">upstream
        documentation</link> for more details.
      '';
    };

    plugins = mkOption {
      default = [ ];

      description = ''
        Controls run-time loadable plugins available to Traffic Server, as
        well as their configuration.

        Consult the <link xlink:href="${getManualUrl "plugin.config"}">upstream
        documentation</link> for more details.
      '';

      type = with types;
        listOf (submodule {
          options.path = mkOption {
            type = str;
            example = "xdebug.so";
            description = ''
              Path to plugin. The path can either be absolute, or relative to
              the plugin directory.
            '';
          };
          options.arg = mkOption {
            type = str;
            default = "";
            example = "--header=ATS-My-Debug";
            description = "arguments to pass to the plugin";
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
      example = literalExample { proxy.config.proxy_name = "my_server"; };
      description = ''
        List of configurable variables used by Traffic Server.

        Consult the <link xlink:href="${getManualUrl "records.config"}">
        upstream documentation</link> for more details.
      '';
    };

    remap = mkOption {
      type = types.lines;
      default = "";
      example = "map http://from.example http://origin.example";
      description = ''
        URL remapping rules used by Traffic Server.

        Consult the <link xlink:href="${getManualUrl "remap.config"}">
        upstream documentation</link> for more details.
      '';
    };

    splitDns = mkOption {
      type = types.lines;
      default = "";
      example = ''
        dest_domain=internal.corp.example named="255.255.255.255:212 255.255.255.254" def_domain=corp.example search_list="corp.example corp1.example"
        dest_domain=!internal.corp.example named=255.255.255.253
      '';
      description = ''
        Specify the DNS server that Traffic Server should use under specific
        conditions.

        Consult the <link xlink:href="${getManualUrl "splitdns.config"}">
        upstream documentation</link> for more details.
      '';
    };

    sslMulticert = mkOption {
      type = types.lines;
      default = "";
      example = "dest_ip=* ssl_cert_name=default.pem";
      description = ''
        Configure SSL server certificates to terminate the SSL sessions.

        Consult the <link xlink:href="${getManualUrl "ssl_multicert.config"}">
        upstream documentation</link> for more details.
      '';
    };

    sni = mkOption {
      type = types.nullOr yaml.type;
      default = null;
      example = literalExample {
        sni = [{
          fqdn = "no-http2.example.com";
          https = "off";
        }];
      };
      description = ''
        Configure aspects of TLS connection handling for both inbound and
        outbound connections.

        Consult the <link xlink:href="${getManualUrl "sni.yaml"}">upstream
        documentation</link> for more details.
      '';
    };

    storage = mkOption {
      type = types.lines;
      default = "/var/cache/trafficserver 256M";
      example = "/dev/disk/by-id/XXXXX volume=1";
      description = ''
        List all the storage that make up the Traffic Server cache.

        Consult the <link xlink:href="${getManualUrl "storage.config"}">
        upstream documentation</link> for more details.
      '';
    };

    strategies = mkOption {
      type = types.nullOr yaml.type;
      default = null;
      description = ''
        Specify the next hop proxies used in an cache hierarchy and the
        algorithms used to select the next proxy.

        Consult the <link xlink:href="${getManualUrl "strategies.yaml"}">
        upstream documentation</link> for more details.
      '';
    };

    volume = mkOption {
      type = types.nullOr yaml.type;
      default = "";
      example = "volume=1 scheme=http size=20%";
      description = ''
        Manage cache space more efficiently and restrict disk usage by
        creating cache volumes of different sizes.

        Consult the <link xlink:href="${getManualUrl "volume.config"}">
        upstream documentation</link> for more details.
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
