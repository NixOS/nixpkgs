{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dnsmasq;
  dnsmasq = pkgs.dnsmasq;
  stateDir = "/var/lib/dnsmasq";

  # True values are just put as `name` instead of `name=true`, and false values
  # are turned to comments (false values are expected to be overrides e.g.
  # mkForce)
  formatKeyValue =
    name: value:
    if value == true
    then name
    else if value == false
    then "# setting `${name}` explicitly set to false"
    else generators.mkKeyValueDefault { } "=" name value;

  settingsFormat = pkgs.formats.keyValue {
    mkKeyValue = formatKeyValue;
    listsAsDuplicateKeys = true;
  };

  # Because formats.generate is outputting a file, we use of conf-file. Once
  # `extraConfig` is deprecated we can just use
  # `dnsmasqConf = format.generate "dnsmasq.conf" cfg.settings`
  dnsmasqConf = pkgs.writeText "dnsmasq.conf" ''
    conf-file=${settingsFormat.generate "dnsmasq.conf" cfg.settings}
    ${cfg.extraConfig}
  '';

in

{

  imports = [
    (mkRenamedOptionModule [ "services" "dnsmasq" "servers" ] [ "services" "dnsmasq" "settings" "server" ])
  ];

  ###### interface

  options = {

    services.dnsmasq = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to run dnsmasq.
        '';
      };

      resolveLocalQueries = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether dnsmasq should resolve local queries (i.e. add 127.0.0.1 to
          /etc/resolv.conf).
        '';
      };

      alwaysKeepRunning = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If enabled, systemd will always respawn dnsmasq even if shut down manually. The default, disabled, will only restart it on error.
        '';
      };

      settings = mkOption {
        type = types.submodule {

          freeformType = settingsFormat.type;

          options.server = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "8.8.8.8" "8.8.4.4" ];
            description = lib.mdDoc ''
              The DNS servers which dnsmasq should query.
            '';
          };

        };
        default = { };
        description = lib.mdDoc ''
          Configuration of dnsmasq. Lists get added one value per line (empty
          lists and false values don't get added, though false values get
          turned to comments). Gets merged with

              {
                dhcp-leasefile = "${stateDir}/dnsmasq.leases";
                conf-file = optional cfg.resolveLocalQueries "/etc/dnsmasq-conf.conf";
                resolv-file = optional cfg.resolveLocalQueries "/etc/dnsmasq-resolv.conf";
              }
        '';
        example = literalExpression ''
          {
            domain-needed = true;
            dhcp-range = [ "192.168.0.2,192.168.0.254" ];
          }
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration directives that should be added to
          `dnsmasq.conf`.

          This option is deprecated, please use {option}`settings` instead.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    warnings = lib.optional (cfg.extraConfig != "") "Text based config is deprecated, dnsmasq now supports `services.dnsmasq.settings` for an attribute-set based config";

    services.dnsmasq.settings = {
      dhcp-leasefile = mkDefault "${stateDir}/dnsmasq.leases";
      conf-file = mkDefault (optional cfg.resolveLocalQueries "/etc/dnsmasq-conf.conf");
      resolv-file = mkDefault (optional cfg.resolveLocalQueries "/etc/dnsmasq-resolv.conf");
    };

    networking.nameservers =
      optional cfg.resolveLocalQueries "127.0.0.1";

    services.dbus.packages = [ dnsmasq ];

    users.users.dnsmasq = {
      isSystemUser = true;
      group = "dnsmasq";
      description = "Dnsmasq daemon user";
    };
    users.groups.dnsmasq = {};

    networking.resolvconf = mkIf cfg.resolveLocalQueries {
      useLocalResolver = mkDefault true;

      extraConfig = ''
        dnsmasq_conf=/etc/dnsmasq-conf.conf
        dnsmasq_resolv=/etc/dnsmasq-resolv.conf
      '';
    };

    systemd.services.dnsmasq = {
        description = "Dnsmasq Daemon";
        after = [ "network.target" "systemd-resolved.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ dnsmasq ];
        preStart = ''
          mkdir -m 755 -p ${stateDir}
          touch ${stateDir}/dnsmasq.leases
          chown -R dnsmasq ${stateDir}
          touch /etc/dnsmasq-{conf,resolv}.conf
          dnsmasq --test
        '';
        serviceConfig = {
          Type = "dbus";
          BusName = "uk.org.thekelleys.dnsmasq";
          ExecStart = "${dnsmasq}/bin/dnsmasq -k --enable-dbus --user=dnsmasq -C ${dnsmasqConf}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          PrivateTmp = true;
          ProtectSystem = true;
          ProtectHome = true;
          Restart = if cfg.alwaysKeepRunning then "always" else "on-failure";
        };
        restartTriggers = [ config.environment.etc.hosts.source ];
    };
  };
}
