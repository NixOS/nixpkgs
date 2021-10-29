{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.caddy;
  vhostToConfig = vhostName: vhostAttrs: ''
    ${vhostName} ${builtins.concatStringsSep " " vhostAttrs.serverAliases} {
      ${vhostAttrs.extraConfig}
    }
  '';
  configFile = pkgs.writeText "Caddyfile" (builtins.concatStringsSep "\n"
    ([ cfg.config ] ++ (mapAttrsToList vhostToConfig cfg.virtualHosts)));

  formattedConfig = pkgs.runCommand "formattedCaddyFile" { } ''
    ${cfg.package}/bin/caddy fmt ${configFile} > $out
  '';

  tlsConfig = {
    apps.tls.automation.policies = [{
      issuers = [{
        inherit (cfg) ca email;
        module = "acme";
      }];
    }];
  };

  adaptedConfig = pkgs.runCommand "caddy-config-adapted.json" { } ''
    ${cfg.package}/bin/caddy adapt \
      --config ${formattedConfig} --adapter ${cfg.adapter} > $out
  '';
  tlsJSON = pkgs.writeText "tls.json" (builtins.toJSON tlsConfig);

  # merge the TLS config options we expose with the ones originating in the Caddyfile
  configJSON =
    if cfg.ca != null then
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
      in
      pkgs.runCommand "caddy-config.json" { } ''
        ${pkgs.jq}/bin/jq -s '.[0] * ${tlsConfigMerge}' ${adaptedConfig} ${tlsJSON} > $out
      ''
    else
      adaptedConfig;
in
{
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

    virtualHosts = mkOption {
      type = types.attrsOf (types.submodule (import ./vhost-options.nix {
        inherit config lib;
      }));
      default = { };
      example = literalExpression ''
        {
          "hydra.example.com" = {
            serverAliases = [ "www.hydra.example.com" ];
            extraConfig = ''''''
              encode gzip
              log
              root /srv/http
            '''''';
          };
        };
      '';
      description = "Declarative vhost config";
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

    resume = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Use saved config, if any (and prefer over configuration passed with <option>services.caddy.config</option>).
      '';
    };

    ca = mkOption {
      default = "https://acme-v02.api.letsencrypt.org/directory";
      example = "https://acme-staging-v02.api.letsencrypt.org/directory";
      type = types.nullOr types.str;
      description = ''
        Certificate authority ACME server. The default (Let's Encrypt
        production server) should be fine for most people. Set it to null if
        you don't want to include any authority (or if you want to write a more
        fine-graned configuration manually)
      '';
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
      defaultText = literalExpression "pkgs.caddy";
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
        ExecStart = "${cfg.package}/bin/caddy run ${optionalString cfg.resume "--resume"} --config ${configJSON}";
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
