{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.caddy;
  configFile = pkgs.writeText "Caddyfile" cfg.config;

  # v2-specific options
  isCaddy2 = versionAtLeast cfg.package.version "2.0";
  tlsConfig = {
    apps.tls.automation.policies = [{
      issuer = {
        inherit (cfg) ca email;
        module = "acme";
      };
    }];
  };

  adaptedConfig = pkgs.runCommand "caddy-config-adapted.json" { } ''
    ${cfg.package}/bin/caddy adapt \
      --config ${configFile} --adapter ${cfg.adapter} > $out
  '';
  tlsJSON = pkgs.writeText "tls.json" (builtins.toJSON tlsConfig);
  configJSON = pkgs.runCommand "caddy-config.json" { } ''
    ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${adaptedConfig} ${tlsJSON} > $out
  '';
in {
  imports = [
    (mkRemovedOptionModule [ "services" "caddy" "agree" ] "this option is no longer necessary for Caddy 2")
  ];

  options.services.caddy = {
    enable = mkEnableOption "Caddy web server";

    config = mkOption {
      default = "";
      example = ''
        example.com {
          encode gzip
          log
          root /srv/http
        }
      '';
      type = types.lines;
      description = ''
        Verbatim Caddyfile to use.
        Caddy v2 supports multiple config formats via adapters (see <option>services.caddy.adapter</option>).
      '';
    };

    adapter = mkOption {
      default = "caddyfile";
      example = "nginx";
      type = types.str;
      description = ''
        Name of the config adapter to use. Not applicable to Caddy v1.
        See https://caddyserver.com/docs/config-adapters for the full list.
      '';
    };

    ca = mkOption {
      default = "https://acme-v02.api.letsencrypt.org/directory";
      example = "https://acme-staging-v02.api.letsencrypt.org/directory";
      type = types.str;
      description = "Certificate authority ACME server. The default (Let's Encrypt production server) should be fine for most people.";
    };

    email = mkOption {
      default = "";
      type = types.str;
      description = "Email address (for Let's Encrypt certificate)";
    };

    dataDir = mkOption {
      default = "/var/lib/caddy";
      type = types.path;
      description = ''
        The data directory, for storing certificates. Before 17.09, this
        would create a .caddy directory. With 17.09 the contents of the
        .caddy directory are in the specified data directory instead.

        Caddy v2 replaced CADDYPATH with XDG directories.
        See https://caddyserver.com/docs/conventions#file-locations.
      '';
    };

    package = mkOption {
      default = pkgs.caddy;
      defaultText = "pkgs.caddy";
      example = "pkgs.caddy1";
      type = types.package;
      description = ''
        Caddy package to use.
        To use Caddy v1 (obsolete), set this to <literal>pkgs.caddy1</literal>.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.caddy = {
      description = "Caddy web server";
      # upstream unit: https://github.com/caddyserver/dist/blob/master/init/caddy.service
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ]; # systemd-networkd-wait-online.service
      wantedBy = [ "multi-user.target" ];
      environment = mkIf (versionAtLeast config.system.stateVersion "17.09" && !isCaddy2)
        { CADDYPATH = cfg.dataDir; };
      serviceConfig = {
        ExecStart = if isCaddy2 then ''
          ${cfg.package}/bin/caddy run --config ${configJSON}
        '' else ''
          ${cfg.package}/bin/caddy -log stdout -log-timestamps=false \
            -root=/var/tmp -conf=${configFile} \
            -ca=${cfg.ca} -email=${cfg.email} ${optionalString cfg.agree "-agree"}
        '';
        ExecReload =
          if isCaddy2 then
            "${cfg.package}/bin/caddy reload --config ${configJSON}"
          else
            "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
        Type = "simple";
        User = "caddy";
        Group = "caddy";
        Restart = "on-abnormal";
        StartLimitIntervalSec = 14400;
        StartLimitBurst = 10;
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWriteDirectories = cfg.dataDir;
        KillMode = "mixed";
        KillSignal = "SIGQUIT";
        TimeoutStopSec = "5s";
      };
    };

    users.users.caddy = {
      group = "caddy";
      uid = config.ids.uids.caddy;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.caddy.gid = config.ids.uids.caddy;
  };
}
