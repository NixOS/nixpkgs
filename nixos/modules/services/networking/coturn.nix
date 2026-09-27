{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.coturn;
  format = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } "=";
  };
  configFile =
    (format.generate "turnserver.conf" (
      cfg.settings
      //
        lib.optionalAttrs
          (cfg.settings.static-auth-secret or null == null && cfg.staticAuthSecretFile != null)
          {
            static-auth-secret = "#static-auth-secret#";
          }
    )).overrideAttrs
      (oldAttrs: {
        text = oldAttrs.text + "\n" + cfg.extraConfig;
      });
in
{
  # Added 03/2026
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "coturn" "static-auth-secret-file" ]
      [ "services" "coturn" "staticAuthSecretFile" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "coturn" "listening-ips" ]
      [ "services" "coturn" "settings" "listening-ip" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "coturn" "relay-ips" ]
      [ "services" "coturn" "settings" "relay-ip" ]
    )
  ]
  ++
    map (x: (lib.mkRenamedOptionModule [ "services" "coturn" x ] [ "services" "coturn" "settings" x ]))
      [
        "static-auth-secret"
        "listening-port"
        "alt-listening-port"
        "tls-listening-port"
        "alt-tls-listening-port"
        "min-port"
        "max-port"
        "lt-cred-mech"
        "no-auth"
        "use-auth-secret"
        "realm"
        "cert"
        "pkey"
        "dh-file"
        "secure-stun"
        "no-cli"
        "cli-ip"
        "cli-port"
        "cli-password"
        "no-udp"
        "no-tcp"
        "no-tls"
        "no-dtls"
        "no-udp-relay"
        "no-tcp-relay"
        "pidfile"
      ];

  options = {
    services.coturn = {
      enable = lib.mkEnableOption "coturn TURN server";
      package = lib.mkPackageOption pkgs "coturn" { };
      staticAuthSecretFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Path to the file containing the static authentication secret.
        '';
      };
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;
        };
        default = { };
        description = ''
          Coturn TURN SERVER configuration settings
          see: https://github.com/coturn/coturn/blob/master/examples/etc/turnserver.conf
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional configuration options";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.static-auth-secret or null != null -> cfg.staticAuthSecretFile == null;
        message = "static-auth-secret and static-auth-secret-file cannot be set at the same time";
      }
    ];

    services.coturn.settings = {
      realm = lib.mkDefault config.networking.hostName;
      pidfile = lib.mkDefault "/run/turnserver/turnserver.pid";
    };

    users.users.turnserver = {
      uid = config.ids.uids.turnserver;
      group = "turnserver";
      description = "coturn TURN server user";
    };
    users.groups.turnserver = {
      gid = config.ids.gids.turnserver;
      members = [ "turnserver" ];
    };

    systemd.services.coturn =
      let
        runConfig = "/run/coturn/turnserver.cfg";
      in
      {
        description = "coturn TURN server";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.Documentation = "man:coturn(1) man:turnadmin(1) man:turnserver(1)";

        preStart = ''
          cat ${configFile} > ${runConfig}
          ${lib.optionalString (cfg.staticAuthSecretFile != null) ''
            ${lib.getExe pkgs.replace-secret} \
              "#static-auth-secret#" \
              ${cfg.staticAuthSecretFile} \
              ${runConfig}
          ''}
          chmod 640 ${runConfig}
        '';
        serviceConfig =
          let
            caps =
              if
                builtins.any
                  (
                    x:
                    let
                      attr = cfg.settings.${x} or null;
                    in
                    builtins.isInt attr -> attr < 1024
                  )
                  [
                    "listening-port"
                    "alt-listening-port"
                    "tls-listening-port"
                    "alt-tls-listening-port"
                    "min-port"
                  ]
              then
                [ "CAP_NET_BIND_SERVICE" ]
              else
                [ "" ];
          in
          {
            Type = "notify";
            ExecStart = "${lib.getExe' cfg.package "turnserver"} -c '${runConfig}'";

            User = "turnserver";
            Group = "turnserver";
            RuntimeDirectory = [
              "coturn"
              "turnserver"
            ];
            RuntimeDirectoryMode = "0700";
            Restart = "on-abort";

            # Hardening
            AmbientCapabilities = caps;
            CapabilityBoundingSet = caps;
            DevicePolicy = "closed";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProcSubset = "pid";
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RemoveIPC = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ]
            ++ lib.optionals (cfg.settings.listening-ip or [ ] == [ ]) [
              # only used for interface discovery when no listening ips are configured
              "AF_NETLINK"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged @resources"
            ];
            UMask = "0077";
          };
      };
  };
}
