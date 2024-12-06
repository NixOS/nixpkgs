{ config, lib, pkgs, ... }:

with lib;

let
  format = pkgs.formats.yaml {};
in
{
  options.services.pomerium = {
    enable = mkEnableOption "the Pomerium authenticating reverse proxy";

    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = "Path to Pomerium config YAML. If set, overrides services.pomerium.settings.";
    };

    useACMEHost = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        If set, use a NixOS-generated ACME certificate with the specified name.

        Note that this will require you to use a non-HTTP-based challenge, or
        disable Pomerium's in-built HTTP redirect server by setting
        http_redirect_addr to null and use a different HTTP server for serving
        the challenge response.

        If you're using an HTTP-based challenge, you should use the
        Pomerium-native autocert option instead.
      '';
    };

    settings = mkOption {
      description = ''
        The contents of Pomerium's config.yaml, in Nix expressions.

        Specifying configFile will override this in its entirety.

        See [the Pomerium
        configuration reference](https://pomerium.io/reference/) for more information about what to put
        here.
      '';
      default = {};
      type = format.type;
    };

    secretsFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to file containing secrets for Pomerium, in systemd
        EnvironmentFile format. See the systemd.exec(5) man page.
      '';
    };
  };

  config = let
    cfg = config.services.pomerium;
    cfgFile = if cfg.configFile != null then cfg.configFile else (format.generate "pomerium.yaml" cfg.settings);
  in mkIf cfg.enable ({
    systemd.services.pomerium = {
      description = "Pomerium authenticating reverse proxy";
      wants = [ "network.target" ] ++ (optional (cfg.useACMEHost != null) "acme-finished-${cfg.useACMEHost}.target");
      after = [ "network.target" ] ++ (optional (cfg.useACMEHost != null) "acme-finished-${cfg.useACMEHost}.target");
      wantedBy = [ "multi-user.target" ];
      environment = optionalAttrs (cfg.useACMEHost != null) {
        CERTIFICATE_FILE = "fullchain.pem";
        CERTIFICATE_KEY_FILE = "key.pem";
      };
      startLimitIntervalSec = 60;
      script = ''
        if [[ -v CREDENTIALS_DIRECTORY ]]; then
          cd "$CREDENTIALS_DIRECTORY"
        fi
        exec "${pkgs.pomerium}/bin/pomerium" -config "${cfgFile}"
      '';

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = [ "pomerium" ];

        PrivateUsers = false;  # breaks CAP_NET_BIND_SERVICE
        MemoryDenyWriteExecute = false;  # breaks LuaJIT

        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";

        EnvironmentFile = cfg.secretsFile;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        LoadCredential = optionals (cfg.useACMEHost != null) [
          "fullchain.pem:/var/lib/acme/${cfg.useACMEHost}/fullchain.pem"
          "key.pem:/var/lib/acme/${cfg.useACMEHost}/key.pem"
        ];
      };
    };

    security.acme.certs = mkIf (cfg.useACMEHost != null) {
      ${cfg.useACMEHost} = {
        reloadServices = [ "pomerium.service" ];
      };
    };
  });
}
