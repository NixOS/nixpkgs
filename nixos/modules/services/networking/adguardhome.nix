{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.adguardhome;
  opt = options.services.adguardhome;
  settingsFormat = pkgs.formats.yaml { };

  defaultHost = "0.0.0.0";
  defaultPort = 3000;

  args = lib.concatStringsSep " " (
    [
      "--no-check-update"
      "--pidfile /run/AdGuardHome/AdGuardHome.pid"
      "--work-dir /var/lib/AdGuardHome/"
      "--config /var/lib/AdGuardHome/AdGuardHome.yaml"
    ]
    ++ cfg.extraArgs
  );

  minimumSchemaVersion = 23;

  webPort =
    if cfg.settings != null then
      lib.toInt (lib.last (lib.splitString ":" cfg.settings.http.address))
    else
      defaultPort;

  configFile = (settingsFormat.generate "AdGuardHome.yaml" cfg.settings).overrideAttrs (_: {
    checkPhase = "${cfg.package}/bin/AdGuardHome -c $out --check-config";
  });
in
{
  options.services.adguardhome = with lib.types; {
    enable = lib.mkEnableOption "AdGuard Home network-wide ad blocker";

    package = lib.mkOption {
      type = package;
      default = pkgs.adguardhome;
      defaultText = lib.literalExpression "pkgs.adguardhome";
      description = ''
        The package that runs adguardhome.
      '';
    };

    openFirewall = lib.mkOption {
      default = false;
      type = bool;
      description = ''
        Open ports in the firewall for the AdGuard Home web interface. Does not
        open the port needed to access the DNS resolver.
      '';
    };

    allowDHCP = lib.mkOption {
      default = cfg.settings.dhcp.enabled or false;
      defaultText = lib.literalExpression "config.services.adguardhome.settings.dhcp.enabled or false";
      type = bool;
      description = ''
        Allows AdGuard Home to open raw sockets (`CAP_NET_RAW`), which is
        required for the integrated DHCP server.

        The default enables this conditionally if the declarative configuration
        enables the integrated DHCP server. Manually setting this option is only
        required for non-declarative setups.
      '';
    };

    mutableSettings = lib.mkOption {
      default = true;
      type = bool;
      description = ''
        Allow changes made on the AdGuard Home web interface to persist between
        service restarts.
      '';
    };

    # deprecated in favor of `settings.http.address`
    host = lib.mkOption {
      type = nullOr str;
      default = null;
      visible = false;
    };
    port = lib.mkOption {
      type = nullOr port;
      default = null;
      visible = false;
    };

    settings = lib.mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = settingsFormat.type;
        options = {
          schema_version = lib.mkOption {
            default = cfg.package.schema_version;
            defaultText = lib.literalExpression "cfg.package.schema_version";
            type = int;
            description = ''
              Schema version for the configuration.
              Defaults to the `schema_version` supplied by `cfg.package`.
            '';
          };

          http.address = lib.mkOption {
            default = "${defaultHost}:${toString defaultPort}";
            type = str;
            description = ''
              Address to serve the web interface on, in the `host:port` format.
            '';
          };
        };
      });
      description = ''
        AdGuard Home configuration. Refer to
        <https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file>
        for details on supported values.

        ::: {.note}
        On start and if {option}`mutableSettings` is `true`,
        these options are merged into the configuration file on start, taking
        precedence over configuration changes made on the web interface.

        Set this to `null` (default) for a non-declarative configuration without any
        Nix-supplied values.
        Declarative configurations are supplied with a default `schema_version`, and `http.address`.
        :::
      '';
    };

    extraArgs = lib.mkOption {
      default = [ ];
      type = listOf str;
      description = ''
        Extra command line parameters to be passed to the adguardhome binary.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      lib.concatMap
        (
          name:
          lib.optional (cfg.${name} != null) ''
            The option `services.adguardhome.${name}' defined in ${
              lib.showFiles opt.${name}.files
            } is deprecated, set `services.adguardhome.settings.http.address' instead.
          ''
        )
        [
          "host"
          "port"
        ];

    services.adguardhome.settings = lib.mkIf (cfg.host != null || cfg.port != null) {
      http.address = "${lib.defaultTo defaultHost cfg.host}:${toString (lib.defaultTo defaultPort cfg.port)}";
    };

    assertions = [
      {
        assertion = cfg.settings != null -> cfg.settings.schema_version >= minimumSchemaVersion;
        message = "AdGuard option `settings.schema_version' must be at least ${toString minimumSchemaVersion}";
      }
      {
        assertion =
          cfg.settings != null
          -> cfg.mutableSettings || lib.hasAttrByPath [ "dns" "bootstrap_dns" ] cfg.settings;
        message = "AdGuard setting dns.bootstrap_dns needs to be configured for a minimal working configuration";
      }
      {
        assertion =
          cfg.settings != null
          ->
            cfg.mutableSettings
            ||
              lib.hasAttrByPath [ "dns" "bootstrap_dns" ] cfg.settings
              && lib.isList cfg.settings.dns.bootstrap_dns;
        message = "AdGuard setting dns.bootstrap_dns needs to be a list";
      }
    ];

    systemd.services.adguardhome = {
      description = "AdGuard Home: Network-level blocker";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        StartLimitIntervalSec = 5;
        StartLimitBurst = 10;
      };

      preStart =
        let
          installFresh = ''
            cp --force "${configFile}" "$STATE_DIRECTORY/AdGuardHome.yaml"
            chmod 600 "$STATE_DIRECTORY/AdGuardHome.yaml"
          '';
        in
        lib.optionalString (cfg.settings != null) (
          if cfg.mutableSettings then
            ''
              if [ -e "$STATE_DIRECTORY/AdGuardHome.yaml" ]; then
                # First run a schema_version update on the existing configuration
                # This ensures that both the new config and the existing one have the same schema_version
                # Note: --check-config has the side effect of modifying the file at rest!
                ${lib.getExe cfg.package} -c "$STATE_DIRECTORY/AdGuardHome.yaml" --check-config

                # sed operation needed to fix protection_disabled_until value changed by yaml-merge
                ${lib.getExe pkgs.yaml-merge} "$STATE_DIRECTORY/AdGuardHome.yaml" "${configFile}" \
                | sed -E "s/(protection_disabled_until: [0-9]{4}-[0-9]{2}-[0-9]{2}) /\1T/" > "$STATE_DIRECTORY/AdGuardHome.yaml.tmp"
                mv "$STATE_DIRECTORY/AdGuardHome.yaml.tmp" "$STATE_DIRECTORY/AdGuardHome.yaml"
              else
                ${installFresh}
              fi
            ''
          else
            installFresh
        );

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} ${args}";
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ] ++ lib.optionals cfg.allowDHCP [ "CAP_NET_RAW" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ] ++ lib.optionals cfg.allowDHCP [ "CAP_NET_RAW" ];
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "AdGuardHome";
        StateDirectory = "AdGuardHome";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallArchitectures = "native";
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_NETLINK"
          "AF_INET"
          "AF_INET6"
        ]
        # AF_UNIX to be able to connect to e.g. /dev/log
        ++ lib.optionals (cfg.settings.log.file or "" == "syslog") [ "AF_UNIX" ]
        ++ lib.optionals cfg.allowDHCP [ "AF_PACKET" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ webPort ];
  };
}
