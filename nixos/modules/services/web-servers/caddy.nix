{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.caddy;
  configFile = pkgs.writeText "Caddyfile" cfg.config;

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

  # merge the TLS config options we expose with the ones originating in the Caddyfile
  configJSON =
    let tlsConfigMerge = ''
      {"apps":
        {"tls":
          {"automation":
            {"policies":
              (if .[0].apps.tls.automation.policies == .[1]?.apps.tls.automation.policies
               then .[0].apps.tls.automation.policies
               else (.[0].apps.tls.automation.policies + .[1]?.apps.tls.automation.policies)
               end)
            }
          }
        }
      }'';
    in pkgs.runCommand "caddy-config.json" { } ''
    ${pkgs.jq}/bin/jq -s '.[0] * ${tlsConfigMerge}' ${adaptedConfig} ${tlsJSON} > $out
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

    user = mkOption {
      default = "caddy";
      type = types.str;
      description = "User account under which caddy runs.";
    };

    group = mkOption {
      default = "caddy";
      type = types.str;
      description = "Group account under which caddy runs.";
    };

    adapter = mkOption {
      default = "caddyfile";
      example = "nginx";
      type = types.str;
      description = ''
        Name of the config adapter to use.
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
      example = "pkgs.caddy";
      type = types.package;
      description = ''
        Caddy package to use.
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
      startLimitIntervalSec = 14400;
      startLimitBurst = 10;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/caddy run --config ${configJSON}";
        ExecReload = "${cfg.package}/bin/caddy reload --config ${configJSON}";
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-abnormal";
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

    users.users = optionalAttrs (cfg.user == "caddy") {
      caddy = {
        group = cfg.group;
        uid = config.ids.uids.caddy;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "caddy") {
      caddy.gid = config.ids.gids.caddy;
    };

  };
}
