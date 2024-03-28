{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption types;

  cfg = config.services.wg-access-server;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{

  options.services.wg-access-server = {
    enable = mkEnableOption "wg-access-server";

    package = mkPackageOption pkgs "wg-access-server" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      description = "See https://www.freie-netze.org/wg-access-server/2-configuration/ for possible options";
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
        (attrPath:
          {
            assertion = !lib.hasAttrByPath attrPath config.services.wg-access-server.settings;
            message = ''
              {option}`services.wg-access-server.settings.${lib.concatStringsSep "." attrPath}` must befinded
              in {option}`services.wg-access-server.secretsFile`.
            '';
          })
        [
          [ "adminPassword" ]
          [ "wireguard" "privateKey" ]
          [ "auth" "sessionStore" ]
          [ "auth" "oidc" "clientSecret" ]
          [ "auth" "gitlab" "clientSecret" ]
        ];

    services.wg-access-server.settings = {
      storage = lib.mkDefault "sqlite3://db.sqlite";
      dns.enabled = lib.mkDefault true;
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = "1";
      "net.ipv6.conf.all.forwarding" = "1";
    };

    systemd.services.wg-access-server = {
      description = "WG access server";
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      script = ''
        # wg-access-server expects the frontend to be in in the cwd
        mkdir -p $STATE_DIRECTORY/website
        rm -f $STATE_DIRECTORY/website/build
        ln -s ${cfg.package}/site/ $STATE_DIRECTORY/website/build

        # merge secrets into main config
        yq eval-all "select(fileIndex == 0) * select(fileIndex == 1)" ${configFile} $CREDENTIALS_DIRECTORY/SECRETS_FILE \
          > "$STATE_DIRECTORY/config.yml"

        ${lib.getExe cfg.package} serve --config "$STATE_DIRECTORY/config.yml"
      '';

      path = with pkgs; [
        iptables
        # needed by startup script
        yq-go
      ];

      serviceConfig =
        let
          capabilities = [
            "CAP_NET_ADMIN"
          ] ++ lib.optional cfg.settings.dns.enabled "CAP_NET_BIND_SERVICE";
        in
        {
          WorkingDirectory = "/var/lib/wg-access-server";
          StateDirectory = "wg-access-server";

          LoadCredential = [
            "SECRETS_FILE:${cfg.secretsFile}"
          ];

          # Hardening
          DynamicUser = true;
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
        };
    };
  };
}
