{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pdns-recursor;

  oneOrMore = type: with types; either type (listOf type);
  valueType =
    with types;
    oneOf [
      int
      str
      bool
      path
    ];
  configType = with types; attrsOf (nullOr (oneOrMore valueType));

  serialize =
    val:
    with types;
    if str.check val then
      val
    else if int.check val then
      toString val
    else if path.check val then
      toString val
    else if bool.check val then
      boolToYesNo val
    else if builtins.isList val then
      (concatMapStringsSep "," serialize val)
    else
      "";

  settingsFormat = pkgs.formats.yaml { };

  mkDefaultAttrs = mapAttrs (n: v: mkDefault v);

  mkForwardZone = mapAttrsToList (
    zone: uri: {
      inherit zone;
      forwarders = [ uri ];
    }
  );

  configFile =
    if cfg.old-settings != { } then
      # Convert recursor.conf to recursor.yml and merge it
      let
        conf = pkgs.writeText "recursor.conf" (
          concatStringsSep "\n" (mapAttrsToList (name: val: "${name}=${serialize val}") cfg.old-settings)
        );

        yaml = settingsFormat.generate "recursor.yml" cfg.yaml-settings;
      in
      pkgs.runCommand "recursor-merged.yml" { } ''
        ${pkgs.pdns-recursor}/bin/rec_control show-yaml --config ${conf} > override.yml
        ${pkgs.yq-go}/bin/yq '. *= load("override.yml")' ${yaml} > $out
      ''
    else
      settingsFormat.generate "recursor.yml" cfg.yaml-settings;

in
{
  options.services.pdns-recursor = {
    enable = mkEnableOption "PowerDNS Recursor, a recursive DNS server";

    dns.address = mkOption {
      type = oneOrMore types.str;
      default = [
        "::"
        "0.0.0.0"
      ];
      description = ''
        IP addresses Recursor DNS server will bind to.
      '';
    };

    dns.port = mkOption {
      type = types.port;
      default = 53;
      description = ''
        Port number Recursor DNS server will bind to.
      '';
    };

    dns.allowFrom = mkOption {
      type = types.listOf types.str;
      default = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "100.64.0.0/10"
        "169.254.0.0/16"
        "192.168.0.0/16"
        "172.16.0.0/12"
        "::1/128"
        "fc00::/7"
        "fe80::/10"
      ];
      example = [
        "0.0.0.0/0"
        "::/0"
      ];
      description = ''
        IP address ranges of clients allowed to make DNS queries.
      '';
    };

    api.address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        IP address Recursor REST API server will bind to.
      '';
    };

    api.port = mkOption {
      type = types.port;
      default = 8082;
      description = ''
        Port number Recursor REST API server will bind to.
      '';
    };

    api.allowFrom = mkOption {
      type = types.listOf types.str;
      default = [
        "127.0.0.1"
        "::1"
      ];
      example = [
        "0.0.0.0/0"
        "::/0"
      ];
      description = ''
        IP address ranges of clients allowed to make API requests.
      '';
    };

    exportHosts = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to export names and IP addresses defined in /etc/hosts.
      '';
    };

    forwardZones = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        DNS zones to be forwarded to other authoritative servers.
      '';
    };

    forwardZonesRecurse = mkOption {
      type = types.attrs;
      example = {
        eth = "[::1]:5353";
      };
      default = { };
      description = ''
        DNS zones to be forwarded to other recursive servers.
      '';
    };

    dnssecValidation = mkOption {
      type = types.enum [
        "off"
        "process-no-validate"
        "process"
        "log-fail"
        "validate"
      ];
      default = "validate";
      description = ''
        Controls the level of DNSSEC processing done by the PowerDNS Recursor.
        See <https://doc.powerdns.com/md/recursor/dnssec/> for a detailed explanation.
      '';
    };

    serveRFC1918 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to directly resolve the RFC1918 reverse-mapping domains:
        `10.in-addr.arpa`,
        `168.192.in-addr.arpa`,
        `16-31.172.in-addr.arpa`
        This saves load on the AS112 servers.
      '';
    };

    old-settings = mkOption {
      type = configType;
      default = { };
      example = literalExpression ''
        {
          loglevel = 8;
          log-common-errors = true;
        }
      '';
      description = ''
        Older PowerDNS Recursor settings. Use this option to configure
        Recursor settings not exposed in a NixOS option or to bypass one.
        See the full documentation at
        <https://doc.powerdns.com/recursor/settings.html>
        for the available options.

        ::: {.warning}
        This option is provided for backward compatibility only
        and will be removed in the next release of NixOS.
        :::
      '';
    };

    yaml-settings = mkOption {
      type = settingsFormat.type;
      default = { };
      example = literalExpression ''
        {
          loglevel = 8;
          log-common-errors = true;
        }
      '';
      description = ''
        PowerDNS Recursor settings. Use this option to configure Recursor
        settings not exposed in a NixOS option or to bypass one.
        See the full documentation at
        <https://doc.powerdns.com/recursor/yamlsettings.html>
        for the available options.
      '';
    };

    luaConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        The content Lua configuration file for PowerDNS Recursor. See
        <https://doc.powerdns.com/recursor/lua-config/index.html>.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.etc."/pdns-recursor/recursor.yml".source = configFile;

    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    services.pdns-recursor.yaml-settings = {
      incoming = mkDefaultAttrs {
        listen = cfg.dns.address;
        port = cfg.dns.port;
        allow_from = cfg.dns.allowFrom;
      };

      webservice = mkDefaultAttrs {
        address = cfg.api.address;
        port = cfg.api.port;
        allow_from = cfg.api.allowFrom;
      };

      recursor = mkDefaultAttrs {
        forward_zones = mkForwardZone cfg.forwardZones;
        forward_zones_recurse = mkForwardZone cfg.forwardZonesRecurse;
        export_etc_hosts = cfg.exportHosts;
        serve_rfc1918 = cfg.serveRFC1918;
        lua_config_file = pkgs.writeText "recursor.lua" cfg.luaConfig;
        daemon = false;
        write_pid = false;
      };

      dnssec = mkDefaultAttrs {
        validation = cfg.dnssecValidation;
      };

      logging = mkDefaultAttrs {
        timestamp = false;
        disable_syslog = true;
      };
    };

    systemd.packages = [ pkgs.pdns-recursor ];

    systemd.services.pdns-recursor = {
      restartTriggers = [ config.environment.etc."/pdns-recursor/recursor.yml".source ];
      wantedBy = [ "multi-user.target" ];
    };

    users.users.pdns-recursor = {
      isSystemUser = true;
      group = "pdns-recursor";
      description = "PowerDNS Recursor daemon user";
    };

    users.groups.pdns-recursor = { };

    warnings = lib.optional (cfg.old-settings != { }) ''
      pdns-recursor has changed its configuration file format from pdns-recursor.conf
      (mapped to `services.pdns-recursor.old-settings`) to the newer pdns-recursor.yml
      (mapped to `services.pdns-recursor.yaml-settings`).

      Support for the older format will be removed in a future version, so please migrate
      your settings over. See <https://doc.powerdns.com/recursor/yamlsettings.html>.
    '';

  };

  imports = [
    (mkRemovedOptionModule [
      "services"
      "pdns-recursor"
      "extraConfig"
    ] "To change extra Recursor settings use services.pdns-recursor.settings instead.")

    (mkRenamedOptionModule
      [
        "services"
        "pdns-recursor"
        "settings"
      ]
      [
        "services"
        "pdns-recursor"
        "old-settings"
      ]
    )
  ];

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
