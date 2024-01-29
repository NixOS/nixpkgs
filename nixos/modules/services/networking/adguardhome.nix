{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.adguardhome;

  args = concatStringsSep " " ([
    "--no-check-update"
    "--pidfile /run/AdGuardHome/AdGuardHome.pid"
    "--work-dir /var/lib/AdGuardHome/"
    "--config /var/lib/AdGuardHome/AdGuardHome.yaml"
  ] ++ cfg.extraArgs);

  configFile = pkgs.writeTextFile {
    name = "AdGuardHome.yaml";
    text = builtins.toJSON cfg.settings;
    checkPhase = "${pkgs.adguardhome}/bin/adguardhome -c $out --check-config";
  };
  defaultBindPort = 3000;

in
{

  imports =
    let cfgPath = [ "services" "adguardhome" ];
    in
    [
      (mkRenamedOptionModuleWith { sinceRelease = 2211; from = cfgPath ++ [ "host" ]; to = cfgPath ++ [ "settings" "bind_host" ]; })
      (mkRenamedOptionModuleWith { sinceRelease = 2211; from = cfgPath ++ [ "port" ]; to = cfgPath ++ [ "settings" "bind_port" ]; })
    ];

  options.services.adguardhome = with types; {
    enable = mkEnableOption (lib.mdDoc "AdGuard Home network-wide ad blocker");

    openFirewall = mkOption {
      default = false;
      type = bool;
      description = lib.mdDoc ''
        Open ports in the firewall for the AdGuard Home web interface. Does not
        open the port needed to access the DNS resolver.
      '';
    };

    allowDHCP = mkOption {
      default = cfg.settings.dhcp.enabled or false;
      defaultText = literalExpression ''config.services.adguardhome.settings.dhcp.enabled or false'';
      type = bool;
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        Allow changes made on the AdGuard Home web interface to persist between
        service restarts.
      '';
    };

    settings = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = (pkgs.formats.yaml { }).type;
        options = {
          schema_version = mkOption {
            default = pkgs.adguardhome.schema_version;
            defaultText = literalExpression "pkgs.adguardhome.schema_version";
            type = int;
            description = lib.mdDoc ''
              Schema version for the configuration.
              Defaults to the `schema_version` supplied by `pkgs.adguardhome`.
            '';
          };
          bind_host = mkOption {
            default = "0.0.0.0";
            type = str;
            description = lib.mdDoc ''
              Host address to bind HTTP server to.
            '';
          };
          bind_port = mkOption {
            default = defaultBindPort;
            type = port;
            description = lib.mdDoc ''
              Port to serve HTTP pages on.
            '';
          };
        };
      });
      description = lib.mdDoc ''
        AdGuard Home configuration. Refer to
        <https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file>
        for details on supported values.

        ::: {.note}
        On start and if {option}`mutableSettings` is `true`,
        these options are merged into the configuration file on start, taking
        precedence over configuration changes made on the web interface.

        Set this to `null` (default) for a non-declarative configuration without any
        Nix-supplied values.
        Declarative configurations are supplied with a default `schema_version`, `bind_host`, and `bind_port`.
        :::
      '';
    };

    extraArgs = mkOption {
      default = [ ];
      type = listOf str;
      description = lib.mdDoc ''
        Extra command line parameters to be passed to the adguardhome binary.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings != null -> cfg.mutableSettings
          || (hasAttrByPath [ "dns" "bind_host" ] cfg.settings)
          || (hasAttrByPath [ "dns" "bind_hosts" ] cfg.settings);
        message =
          "AdGuard setting dns.bind_host or dns.bind_hosts needs to be configured for a minimal working configuration";
      }
      {
        assertion = cfg.settings != null -> cfg.mutableSettings
          || hasAttrByPath [ "dns" "bootstrap_dns" ] cfg.settings;
        message =
          "AdGuard setting dns.bootstrap_dns needs to be configured for a minimal working configuration";
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

      preStart = optionalString (cfg.settings != null) ''
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
        ExecStart = "${pkgs.adguardhome}/bin/adguardhome ${args}";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ] ++ optionals cfg.allowDHCP [ "CAP_NET_RAW" ];
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "AdGuardHome";
        StateDirectory = "AdGuardHome";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.bind_port or defaultBindPort ];
  };
}
