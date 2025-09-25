{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.crowdsec-firewall-bouncer;
  format = pkgs.formats.yaml { };
in
{
  options.services.crowdsec-firewall-bouncer =
    let
      inherit (lib)
        types
        mkOption
        mkEnableOption
        mkPackageOption
        ;
    in
    {
      enable = mkEnableOption "CrowdSec Firewall Bouncer";

      package = mkPackageOption pkgs "crowdsec-firewall-bouncer" { };

      create_rulesets = mkOption {
        type = types.bool;
        description = ''
          Whether to have the module create the appropriate firewall configuration
          based on the bouncer settings.
          You may disable this option to manually configure it.
        '';
        default = true;
      };

      secrets = {
        api-key-path = mkOption {
          type = types.nullOr types.path;
          description = ''
            Path to the API key to authenticate with the local crowdsec API.

            You need to call `cscli bouncers add <bouncer-name>` to register
            the bouncer and get this API key.
          '';
          default = null;
        };
      };

      settings = mkOption {
        description = ''
          Settings for the main CrowdSec Firewall Bouncer.

          Refer to the defaults at <https://github.com/crowdsecurity/cs-firewall-bouncer/blob/main/config/crowdsec-firewall-bouncer.yaml>.
        '';
        default = { };
        type = types.submodule {
          freeformType = format.type;
          options = {
            mode = mkOption {
              type = types.str;
              description = "Firewall mode to use.";
              default = if config.networking.nftables.enable then "nftables" else "iptables";
              defaultText = lib.literalExpression ''if config.networking.nftables.enable then "nftables" else "iptables"'';
            };
            api_url = mkOption {
              type = types.str;
              description = "URL of the local API.";
              example = "http://127.0.0.1:8080";
              default = "http://${config.services.crowdsec.settings.general.api.server.listen_uri}";
              defaultText = lib.literalExpression ''http://$\{config.services.crowdsec.settings.general.api.server.listen_uri}'';
            };
            api_key = mkOption {
              type = types.nullOr types.str;
              description = ''
                API key to authenticate with the local crowdsec API.

                You need to call `cscli bouncers add <bouncer-name>` to register
                the bouncer and get this API key.

                Setting this option will store this secret in the Nix store.
                Instead, you should set the `services.crowdsec-firewall-bouncer.secrets.api-key-path`
                option, which will read the value at runtime.
              '';
              default = if cfg.secrets.api-key-path != null then "@API_KEY_FILE@" else null;
              defaultText = lib.literalExpression ''if cfg.secrets.api-key-path != null then "@API_KEY_FILE@" else null'';
            };
          };
        };
      };
    };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.secrets.api-key-path == null && cfg.settings.api_key == null);
        message = ''
          An API key must be set for the bouncer to be able to authenticate to the local crowdsec API.

          See the `services.crowdsec-firewall-bouncer.secrets.api-key-path` option documentation
          for more information.
        '';
      }
      {
        assertion = !(cfg.settings.mode == "ipset" && cfg.create_rulesets);
        message = ''
          The crowdsec-firewall-bouncer module is currently not able to configure the firewall in "ipset" mode.

          Either set the `services.crowdsec-firewall-bouncer.settings.mode` to "iptables" to leave the bouncer
          manage the firewall configuration, or disable the `services.crowdsec-firewall-bouncer.create_rulesets`
          option and manually configure your firewall.
        '';
      }
    ];

    # Default settings
    services.crowdsec-firewall-bouncer.settings = {
      update_frequency = lib.mkDefault "10s";
      log_mode = lib.mkDefault "stdout";
      log_level = lib.mkDefault "info";

      # iptables-specific config
      blacklists_ipv4 = lib.mkDefault "crowdsec-blacklists";
      blacklists_ipv6 = lib.mkDefault "crowdsec6-blacklists";
      iptables_chains = lib.mkDefault [ "INPUT" ];

      # nftables-specific config
      nftables = {
        ipv4 = {
          enabled = lib.mkDefault true;
          set-only = lib.mkDefault true;
          table = lib.mkDefault "crowdsec";
          chain = lib.mkDefault "crowdsec-chain";
        };
        ipv6 = {
          enabled = lib.mkDefault true;
          set-only = lib.mkDefault true;
          table = lib.mkDefault "crowdsec6";
          chain = lib.mkDefault "crowdsec6-chain";
        };
      };
    };

    networking.nftables.tables = lib.mkIf (cfg.settings.mode == "nftables") {
      "${cfg.settings.nftables.ipv4.table}" =
        lib.mkIf
          (cfg.create_rulesets && cfg.settings.nftables.ipv4.enabled && cfg.settings.nftables.ipv4.set-only)
          {
            family = "ip";
            content = ''
              set crowdsec-blacklists {
                type ipv4_addr
                flags timeout
              }

              chain ${cfg.settings.nftables.ipv4.chain} {
                type filter hook input priority filter; policy accept;
                ip saddr @crowdsec-blacklists drop
              }
            '';
          };
      "${cfg.settings.nftables.ipv6.table}" =
        lib.mkIf
          (cfg.create_rulesets && cfg.settings.nftables.ipv6.enabled && cfg.settings.nftables.ipv6.set-only)
          {
            family = "ip6";
            content = ''
              set crowdsec6-blacklists {
                type ipv6_addr
                flags timeout
              }

              chain ${cfg.settings.nftables.ipv6.chain} {
                type filter hook input priority filter; policy accept;
                ip6 saddr @crowdsec6-blacklists drop
              }
            '';
          };
    };

    systemd.services.crowdsec-firewall-bouncer =
      let
        runtime-dir-name = "crowdsec-firewall-bouncer";
        final-config-file = "/run/${runtime-dir-name}/config.yaml";
        generateConfig = pkgs.writeShellScript "crowdsec-firewall-bouncer-config" ''
          set -euo pipefail
          umask 077

          # Copy the template to the final location
          cp ${format.generate "crowdsec-firewall-bouncer-config-template.yml" cfg.settings} ${final-config-file}
          chmod 0600 ${final-config-file}

          # Replace the api_key placeholder with the secret
          ${lib.getExe pkgs.replace-secret} '@API_KEY_FILE@' "$CREDENTIALS_DIRECTORY/API_KEY_FILE" ${final-config-file}
        '';
      in
      rec {
        description = "CrowdSec Firewall Bouncer";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
        ]
        ++ (lib.optional (config.services.crowdsec.enable) "crowdsec.service");
        wants = after;
        serviceConfig = rec {
          Type = "notify";
          ExecStartPre = [
            generateConfig
            "${lib.getExe cfg.package} -c ${final-config-file} -t"
          ];
          ExecStart = [
            "${lib.getExe cfg.package} -c ${final-config-file}"
          ];
          Restart = "always";
          RestartSec = 10;

          # Same as upstream
          LimitNOFILE = 65536;
          KillMode = "mixed";

          # Load the api_key secret to be able to use it when generating the final config
          LoadCredential = lib.optional (
            cfg.secrets.api-key-path != null
          ) "API_KEY_FILE:${cfg.secrets.api-key-path}";

          DynamicUser = true;
          RuntimeDirectory = runtime-dir-name;

          LockPersonality = true;
          PrivateDevices = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";

          RestrictAddressFamilies = [
            "AF_NETLINK"
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          AmbientCapabilities = [
            # Needed to be able to manipulate the rulesets
            "CAP_NET_ADMIN"
          ];
          CapabilityBoundingSet = AmbientCapabilities;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          UMask = "0077";
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ nicomem ];
  };
}
