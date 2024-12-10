{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.adguardhome;
  settingsFormat = pkgs.formats.yaml { };

  args = concatStringsSep " " (
    [
      "--no-check-update"
      "--pidfile /run/AdGuardHome/AdGuardHome.pid"
      "--work-dir /var/lib/AdGuardHome/"
      "--config /var/lib/AdGuardHome/AdGuardHome.yaml"
    ]
    ++ cfg.extraArgs
  );

  settings =
    if (cfg.settings != null) then
      cfg.settings
      // (
        if cfg.settings.schema_version < 23 then
          {
            bind_host = cfg.host;
            bind_port = cfg.port;
          }
        else
          {
            http.address = "${cfg.host}:${toString cfg.port}";
          }
      )
    else
      null;

  configFile = (settingsFormat.generate "AdGuardHome.yaml" settings).overrideAttrs (_: {
    checkPhase = "${cfg.package}/bin/adguardhome -c $out --check-config";
  });
in
{
  options.services.adguardhome = with types; {
    enable = mkEnableOption "AdGuard Home network-wide ad blocker";

    package = mkOption {
      type = package;
      default = pkgs.adguardhome;
      defaultText = literalExpression "pkgs.adguardhome";
      description = ''
        The package that runs adguardhome.
      '';
    };

    openFirewall = mkOption {
      default = false;
      type = bool;
      description = ''
        Open ports in the firewall for the AdGuard Home web interface. Does not
        open the port needed to access the DNS resolver.
      '';
    };

    allowDHCP = mkOption {
      default = settings.dhcp.enabled or false;
      defaultText = literalExpression "config.services.adguardhome.settings.dhcp.enabled or false";
      type = bool;
      description = ''
        Allows AdGuard Home to open raw sockets (`CAP_NET_RAW`), which is
        required for the integrated DHCP server.

        The default enables this conditionally if the declarative configuration
        enables the integrated DHCP server. Manually setting this option is only
        required for non-declarative setups.
      '';
    };

    mutableSettings = mkOption {
      default = true;
      type = bool;
      description = ''
        Allow changes made on the AdGuard Home web interface to persist between
        service restarts.
      '';
    };

    host = mkOption {
      default = "0.0.0.0";
      type = str;
      description = ''
        Host address to bind HTTP server to.
      '';
    };

    port = mkOption {
      default = 3000;
      type = port;
      description = ''
        Port to serve HTTP pages on.
      '';
    };

    settings = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = settingsFormat.type;
        options = {
          schema_version = mkOption {
            default = cfg.package.schema_version;
            defaultText = literalExpression "cfg.package.schema_version";
            type = int;
            description = ''
              Schema version for the configuration.
              Defaults to the `schema_version` supplied by `cfg.package`.
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

    extraArgs = mkOption {
      default = [ ];
      type = listOf str;
      description = ''
        Extra command line parameters to be passed to the adguardhome binary.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings != null -> !(hasAttrByPath [ "bind_host" ] cfg.settings);
        message = "AdGuard option `settings.bind_host' has been superseded by `services.adguardhome.host'";
      }
      {
        assertion = cfg.settings != null -> !(hasAttrByPath [ "bind_port" ] cfg.settings);
        message = "AdGuard option `settings.bind_host' has been superseded by `services.adguardhome.port'";
      }
      {
        assertion =
          settings != null -> cfg.mutableSettings || hasAttrByPath [ "dns" "bootstrap_dns" ] settings;
        message = "AdGuard setting dns.bootstrap_dns needs to be configured for a minimal working configuration";
      }
      {
        assertion =
          settings != null
          ->
            cfg.mutableSettings
            || hasAttrByPath [ "dns" "bootstrap_dns" ] settings && isList settings.dns.bootstrap_dns;
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

      preStart = optionalString (settings != null) ''
        if    [ -e "$STATE_DIRECTORY/AdGuardHome.yaml" ] \
           && [ "${toString cfg.mutableSettings}" = "1" ]; then
          # Writing directly to AdGuardHome.yaml results in empty file
          ${pkgs.yaml-merge}/bin/yaml-merge "$STATE_DIRECTORY/AdGuardHome.yaml" "${configFile}" > "$STATE_DIRECTORY/AdGuardHome.yaml.tmp"
          mv "$STATE_DIRECTORY/AdGuardHome.yaml.tmp" "$STATE_DIRECTORY/AdGuardHome.yaml"
        else
          cp --force "${configFile}" "$STATE_DIRECTORY/AdGuardHome.yaml"
          chmod 600 "$STATE_DIRECTORY/AdGuardHome.yaml"
        fi
      '';

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/adguardhome ${args}";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ] ++ optionals cfg.allowDHCP [ "CAP_NET_RAW" ];
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "AdGuardHome";
        StateDirectory = "AdGuardHome";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
