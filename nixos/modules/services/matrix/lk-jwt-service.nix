{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lk-jwt-service;

  # Environment variables that point to a file and should be routed through systemd's LoadCredential= mechanism.
  credentialVars = [
    "LIVEKIT_KEY_FILE"
    "LIVEKIT_KEY_FROM_FILE"
    "LIVEKIT_SECRET_FROM_FILE"
  ];

  # Returns the credentialVars that have actually been set
  activeCredentialVars = lib.filter (name: cfg.environment.${name} != null) credentialVars;

  # Create a mapping of credentials for systemd to load
  LoadCredential = map (name: "${name}:${cfg.environment.${name}}") activeCredentialVars;

  # Replace old attributes with prefixed credentials paths
  environment =
    (removeAttrs cfg.environment credentialVars)
    // lib.genAttrs activeCredentialVars (name: "%d/${name}");
in
{
  meta.maintainers = [ lib.maintainers.quadradical ];

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "lk-jwt-service" "port" ]
      [ "services" "lk-jwt-service" "environment" "LIVEKIT_JWT_PORT" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "lk-jwt-service" "keyFile" ]
      [ "services" "lk-jwt-service" "environment" "LIVEKIT_KEY_FILE" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "lk-jwt-service" "livekitUrl" ]
      [ "services" "lk-jwt-service" "environment" "LIVEKIT_URL" ]
    )
  ];

  options.services.lk-jwt-service = {
    enable = lib.mkEnableOption "lk-jwt-service";

    package = lib.mkPackageOption pkgs "lk-jwt-service" { };

    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = {
          LIVEKIT_URL = lib.mkOption {
            type = lib.types.strMatching "^wss?://.*";
            example = "wss://example.com/livekit/sfu";
            description = ''
              The public websocket URL for LiveKit.

              The scheme must be either `wss://` (recommended) or `ws://` (insecure).
            '';
          };
          LIVEKIT_KEY_FILE = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/run/secrets/lk-jwt-service.key";
            description = ''
              Path to a file containing the LiveKit key/secret pair in
              `key: secret` form.

              When set, the file is passed to the service via systemd's
              `LoadCredential=` mechanism, so the path does not need to be
              readable by the service's dynamic user directly.
            '';
          };
          LIVEKIT_KEY_FROM_FILE = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/run/secrets/lk-jwt-service.key-id";
            description = ''
              Path to a file containing only the LiveKit API key.

              When set, the file is passed to the service via systemd's
              `LoadCredential=` mechanism.
            '';
          };
          LIVEKIT_SECRET_FROM_FILE = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/run/secrets/lk-jwt-service.secret";
            description = ''
              Path to a file containing only the LiveKit API secret.

              When set, the file is passed to the service via systemd's
              `LoadCredential=` mechanism.
            '';
          };
          LIVEKIT_JWT_BIND = lib.mkOption {
            type = lib.types.strMatching ".*:[0-9]+";
            default = ":8080";
            example = "127.0.0.1:8080";
            description = ''
              Address to bind the server to, in `host:port` form.

              The host part may be omitted to bind on all interfaces (for example, `:8080`).

              This replaces the upstream `LIVEKIT_JWT_PORT` variable, which has been deprecated.
            '';
          };
          LIVEKIT_FULL_ACCESS_HOMESERVERS = lib.mkOption {
            type = lib.types.either (lib.types.enum [ "*" ]) (lib.types.listOf lib.types.str);

            default = "*";
            apply = value: if builtins.isList value then lib.concatStringsSep "," value else value;

            example = [
              "example.com"
              "matrix.org"
            ];

            description = ''
              Homeservers whose users are allowed full access to the LiveKit JWT
              service.

              Set to `"*"` (the default) to allow all homeservers, or provide a
              list of homeserver names to restrict access.
            '';
          };
        };
      };
      default = { };
      description = ''
        Environment variables for configuring lk-jwt-service.
        This field will end up public in /nix/store, for secret values (such as `LIVEKIT_KEY` and `LIVEKIT_SECRET`) use `environmentFile`.

        See <https://github.com/element-hq/lk-jwt-service#%EF%B8%8F-configuration> for available options.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/lk-jwt-service.env";
      description = ''
        Path to an environment file for lk-jwt-service.

        Use this file to supply secret configuration such as `LIVEKIT_KEY`
        and `LIVEKIT_SECRET`. The file must contain lines in the form
        `KEY=value` and should be managed by a secret store such as
        sops-nix or agenix, so that its contents do not end up in the
        Nix store.

        See <https://github.com/element-hq/lk-jwt-service#%EF%B8%8F-configuration>
        for available variables.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.lk-jwt-service = {
      description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
      documentation = [ "https://github.com/element-hq/lk-jwt-service" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      inherit environment;

      serviceConfig = {
        EnvironmentFile = cfg.environmentFile;
        inherit LoadCredential;
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        ProtectHome = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "077";
      };
    };

    warnings = lib.optional (cfg.environment ? LIVEKIT_JWT_PORT) ''
      `services.lk-jwt-service.environment.LIVEKIT_JWT_PORT` is set, but this environment variable is deprecated upstream.

      Use `services.lk-jwt-service.environment.LIVEKIT_JWT_BIND` instead.
    '';
  };
}
