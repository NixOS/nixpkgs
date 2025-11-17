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

      createRulesets = mkOption {
        type = types.bool;
        description = ''
          Whether to have the module create the appropriate firewall configuration
          based on the bouncer settings.
          You may disable this option to manually configure it.
        '';
        default = true;
      };

      registerBouncer = {
        enable = mkOption {
          type = types.bool;
          description = ''
            Whether to automatically register the bouncer to the locally running
            `crowdsec` service.

            When authenticating to an external CrowdSec API, you may use the
            [](#opt-services.crowdsec-firewall-bouncer.secrets.apiKeyPath) option
            instead.
          '';
          default = config.services.crowdsec.enable;
          defaultText = lib.literalExpression ''config.services.crowdsec.enable'';
        };
        bouncerName = mkOption {
          type = types.nonEmptyStr;
          description = "Name to register the bouncer as to the CrowdSec API";
          default = "crowdsec-firewall-bouncer";
        };
      };

      secrets = {
        apiKeyPath = mkOption {
          type = types.nullOr types.path;
          description = ''
            Path to the API key to authenticate with a local CrowdSec API.

            You need to call `cscli bouncers add <bouncer-name>` to register
            the bouncer and get this API key.

            When authenticating to the locally running `crowdsec` service, you may use the
            [](#opt-services.crowdsec-firewall-bouncer.registerBouncer.enable) option instead.
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
                API key to authenticate with a local crowdsec API.

                You need to call `cscli bouncers add <bouncer-name>` to register
                the bouncer and get this API key.

                Setting this option will store this secret in the Nix store.
                Instead, you should set the `services.crowdsec-firewall-bouncer.secrets.apiKeyPath`
                option, which will read the value at runtime.
              '';
              default = null;
            };
          };
        };
      };
    };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.registerBouncer.enable || (cfg.secrets.apiKeyPath != null) || (cfg.settings.api_key != null);
        message = ''
          An API key must be set for the bouncer to be able to authenticate to a local crowdsec API.

          See the `registerBouncer.enable` and `secrets.apiKeyPath` options of
          `services.crowdsec-firewall-bouncer` for more information.
        '';
      }
      {
        assertion = !(cfg.registerBouncer.enable && (cfg.secrets.apiKeyPath != null));
        message = ''
          The `registerBouncer.enable` and `secrets.apiKeyPath` options of
          `services.crowdsec-firewall-bouncer` are mutually exclusive.
        '';
      }
      {
        assertion = !(cfg.registerBouncer.enable && !config.services.crowdsec.enable);
        message = ''
          The `services.crowdsec-firewall-bouncer.registerBouncer.enable` option
          requires the `crowdsec` service to be enabled.
        '';
      }
      {
        assertion = !(cfg.settings.mode == "ipset" && cfg.createRulesets);
        message = ''
          The crowdsec-firewall-bouncer module is currently not able to configure the firewall in "ipset" mode.

          Either set the `services.crowdsec-firewall-bouncer.settings.mode` to "iptables" to leave the bouncer
          manage the firewall configuration, or disable the `services.crowdsec-firewall-bouncer.createRulesets`
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

    # Use a placeholder for the api_key if it is to be read from a file at runtime
    services.crowdsec-firewall-bouncer.settings.api_key = lib.mkIf (
      cfg.registerBouncer.enable || (cfg.secrets.apiKeyPath != null)
    ) "@API_KEY_FILE@";

    networking.nftables.tables = lib.mkIf (cfg.settings.mode == "nftables") {
      "${cfg.settings.nftables.ipv4.table}" =
        lib.mkIf
          (cfg.createRulesets && cfg.settings.nftables.ipv4.enabled && cfg.settings.nftables.ipv4.set-only)
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
          (cfg.createRulesets && cfg.settings.nftables.ipv6.enabled && cfg.settings.nftables.ipv6.set-only)
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

    systemd.services =
      let
        apiKeyFile = "/var/lib/crowdsec-firewall-bouncer-register/api-key.cred";
      in
      {
        crowdsec-firewall-bouncer-register = lib.mkIf cfg.registerBouncer.enable rec {
          description = "Register the CrowdSec Firewall Bouncer to the local CrowdSec service";
          wantedBy = [ "multi-user.target" ];
          after = [ "crowdsec.service" ];
          wants = after;
          script = ''
            cscli=/run/current-system/sw/bin/cscli
            if $cscli bouncers list --output json | ${lib.getExe pkgs.jq} -e -- ${lib.escapeShellArg "any(.[]; .name == \"${cfg.registerBouncer.bouncerName}\")"} >/dev/null; then
              # Bouncer already registered. Verify the API key is still present
              if [ ! -f ${apiKeyFile} ]; then
                echo "Bouncer registered but API key is not present"
                exit 1
              fi
            else
              # Bouncer not registered
              # Remove any previously saved API key
              rm -f '${apiKeyFile}'
              # Register the bouncer and save the new API key
              if ! $cscli bouncers add --output raw -- ${lib.escapeShellArg cfg.registerBouncer.bouncerName} >${apiKeyFile}; then
                # Failed to register the bouncer
                rm ${apiKeyFile}
                exit 1
              fi
            fi
          '';
          serviceConfig = {
            Type = "oneshot";

            # Run as crowdsec user to be able to use cscli
            User = config.services.crowdsec.user;
            Group = config.services.crowdsec.group;

            StateDirectory = "crowdsec-firewall-bouncer-register";

            ReadWritePaths = [
              # Needs write permissions to add the bouncer
              "/var/lib/crowdsec"
            ];

            DynamicUser = true;
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

            RestrictAddressFamilies = "none";
            CapabilityBoundingSet = [ "" ];
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
              "~@resources"
            ];
            UMask = "0077";
          };
        };

        crowdsec-firewall-bouncer =
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
            after = [ "network.target" ] ++ (lib.optional config.services.crowdsec.enable "crowdsec.service");
            wants = after;
            requires = lib.optional cfg.registerBouncer.enable "crowdsec-firewall-bouncer-register.service";

            # When using iptables/ipset modes, the bouncer calls external binaries so they must be added to the path.
            # For nftables mode, it does not depend on external binaries.
            path = lib.optionals ((cfg.settings.mode == "iptables") || (cfg.settings.mode == "ipset")) [
              pkgs.iptables
              pkgs.ipset
            ];

            serviceConfig = rec {
              Type = "notify";
              ExecStartPre = [
                generateConfig
                "${lib.getExe cfg.package} -c ${final-config-file} -t"
              ];
              ExecStart = [
                "${lib.getExe cfg.package} -c ${final-config-file}"
              ];

              # Same as upstream
              LimitNOFILE = 65536;
              KillMode = "mixed";

              # Load the api_key secret to be able to use it when generating the final config
              LoadCredential =
                if (cfg.registerBouncer.enable) then
                  "API_KEY_FILE:${apiKeyFile}"
                else if (cfg.secrets.apiKeyPath != null) then
                  "API_KEY_FILE:${cfg.secrets.apiKeyPath}"
                else
                  null;

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
  };

  meta = {
    maintainers = with lib.maintainers; [ nicomem ];
  };
}
