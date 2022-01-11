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

  baseConfig = {
    bind_host = cfg.host;
    bind_port = cfg.port;
  };

  configFile = pkgs.writeTextFile {
    name = "AdGuardHome.yaml";
    text = builtins.toJSON (recursiveUpdate cfg.settings baseConfig);
    checkPhase = "${pkgs.adguardhome}/bin/adguardhome -c $out --check-config";
  };

in {
  options.services.adguardhome = with types; {
    enable = mkEnableOption "AdGuard Home network-wide ad blocker";

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

    openFirewall = mkOption {
      default = false;
      type = bool;
      description = ''
        Open ports in the firewall for the AdGuard Home web interface. Does not
        open the port needed to access the DNS resolver.
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

    settings = mkOption {
      type = (pkgs.formats.yaml { }).type;
      default = { };
      description = ''
        AdGuard Home configuration. Refer to
        <link xlink:href="https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file"/>
        for details on supported values.

        <note><para>
          On start and if <option>mutableSettings</option> is <literal>true</literal>,
          these options are merged into the configuration file on start, taking
          precedence over configuration changes made on the web interface.
        </para></note>
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
    systemd.services.adguardhome = {
      description = "AdGuard Home: Network-level blocker";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        StartLimitIntervalSec = 5;
        StartLimitBurst = 10;
      };

      preStart = ''
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
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "AdGuardHome";
        StateDirectory = "AdGuardHome";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
