{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  cfg = config.services.wg-access-server;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{

  options.services.wg-access-server = {
    enable = mkEnableOption "wg-access-server";

    package = mkPackageOption pkgs "wg-access-server" { };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          dns.enabled = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable/disable the embedded DNS proxy server.
              This is enabled by default and allows VPN clients to avoid DNS leaks by sending all DNS requests to wg-access-server itself.
            '';
          };
          storage = mkOption {
            type = types.str;
            default = "sqlite3://db.sqlite";
            description = "A storage backend connection string. See [storage docs](https://www.freie-netze.org/wg-access-server/3-storage/)";
          };
        };
      };
      description = "See <https://www.freie-netze.org/wg-access-server/2-configuration/> for possible options";
    };

    secretsFile = mkOption {
      type = types.path;
      description = ''
        yaml file containing all secrets. this needs to be in the same structure as the configuration.

        This must to contain the admin password and wireguard private key.
        As well as the secrets for your auth backend.

        Example:
        ```yaml
        adminPassword: <admin password>
        wireguard:
          privateKey: <wireguard private key>
        auth:
          oidc:
            clientSecret: <client secret>
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      map
        (attrPath: {
          assertion = !lib.hasAttrByPath attrPath config.services.wg-access-server.settings;
          message = ''
            {option}`services.wg-access-server.settings.${lib.concatStringsSep "." attrPath}` must definded
            in {option}`services.wg-access-server.secretsFile`.
          '';
        })
        [
          [ "adminPassword" ]
          [
            "wireguard"
            "privateKey"
          ]
          [
            "auth"
            "sessionStore"
          ]
          [
            "auth"
            "oidc"
            "clientSecret"
          ]
          [
            "auth"
            "gitlab"
            "clientSecret"
          ]
        ];

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = "1";
      "net.ipv6.conf.all.forwarding" = "1";
    };

    systemd.services.wg-access-server = {
      description = "WG access server";
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      path = with pkgs; [
        iptables
      ];

      serviceConfig =
        let
          capabilities = [
            "CAP_NET_ADMIN"
          ]
          ++ lib.optional cfg.settings.dns.enabled "CAP_NET_BIND_SERVICE";
        in
        {
          WorkingDirectory = "/var/lib/wg-access-server";
          StateDirectory = "wg-access-server";

          LoadCredential = [
            "SECRETS_FILE:${cfg.secretsFile}"
          ];

          # merge secrets into main config
          ExecStartPre = [
            "${lib.getExe' pkgs.coreutils "install"} '${configFile}' \"\${STATE_DIRECTORY}\"/config.yml"
            "${lib.getExe pkgs.yq-go} eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \"\${STATE_DIRECTORY}\"/config.yml --inplace \"\${CREDENTIALS_DIRECTORY}\"/SECRETS_FILE"
          ];

          ExecStart = "${lib.getExe cfg.package} serve --config \"\${STATE_DIRECTORY}\"/config.yml";

          # Hardening
          DynamicUser = true;
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
        };
    };
  };
}
