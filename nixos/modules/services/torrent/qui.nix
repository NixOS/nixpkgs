{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    elem
    filterAttrs
    flip
    getExe
    join
    lowerChars
    maintainers
    mapAttrs'
    mkEnableOption
    mkForce
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    nameValuePair
    pipe
    splitStringBy
    toList
    toUpper
    upperChars
    ;
  inherit (lib.generators) mkValueStringDefault;
  inherit (lib.types)
    attrsOf
    bool
    externalPath
    int
    listOf
    nullOr
    oneOf
    port
    str
    submodule
    ;

  cfg = config.services.qui;

  envName = flip pipe [
    (splitStringBy (prev: curr: elem prev lowerChars && elem curr upperChars) true)
    (map toUpper)
    (join "_")
    (s: "QUI__${s}")
  ];
  envValue = flip pipe [
    toList
    (map (mkValueStringDefault { }))
    (join ",")
  ];
  toEnv = flip pipe [
    (filterAttrs (_: v: v != null))
    (mapAttrs' (n: v: nameValuePair (envName n) (envValue v)))
  ];
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "qui" "secretFile" ]
      [ "services" "qui" "settings" "sessionSecretFile" ]
    )
  ];

  options = {
    services.qui = {
      enable = mkEnableOption "qui";

      package = mkPackageOption pkgs "qui" { };

      user = mkOption {
        type = str;
        default = "qui";
        description = "User to run qui as.";
      };

      group = mkOption {
        type = str;
        default = "qui";
        example = "torrents";
        description = "Group to run qui as.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Whether or not to open ports in the firewall for qui.";
      };

      settings = mkOption {
        default = { };
        example = {
          port = 7777;
          logLevel = "DEBUG";
          metricsEnabled = true;
        };
        type = submodule {
          freeformType = attrsOf (oneOf [
            bool
            int
            str
            (listOf str)
          ]);
          options = {
            host = mkOption {
              type = str;
              default = "127.0.0.1";
              description = "The host address qui listens on.";
            };

            port = mkOption {
              type = port;
              default = 7476;
              description = "The port qui listens on.";
            };

            sessionSecretFile = mkOption {
              type = nullOr externalPath;
              example = "/run/secrets/qui-session.txt";
              default = null;
              description = ''
                Path to a file that contains the session secret.
                The session secret can be generated with `openssl rand -hex 32`.

                When null, qui generates and persists its own secret.
              '';
            };
          };
        };
        description = ''
          qui configuration options.

          Refer to the [template config](https://github.com/autobrr/qui/blob/main/internal/config/config.go)
          in the source code for the available options.
          The documentation contains the available [environment variables](https://getqui.com/docs/configuration/environment/),
          this can be used to get an overview.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? sessionSecret);
        message = ''
          `services.qui.settings.sessionSecret` must not be set,
          as it is written to the world-readable nix store.
          Use `services.qui.settings.sessionSecretFile` instead.
        '';
      }
    ];

    systemd.services.qui = mkMerge [
      {
        description = "qui: alternative qBittorrent webUI";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = toEnv cfg.settings;

        serviceConfig = {
          Type = "exec";
          User = cfg.user;
          Group = cfg.group;

          StateDirectory = "%N";
          StateDirectoryMode = "0700";

          ExecStartPre = "${getExe cfg.package} generate-config --config-dir %S/%N";
          ExecStart = "${getExe cfg.package} serve --config-dir %S/%N";
          Restart = "on-failure";

          # Based on qbittorrent and nemorosa hardening settings
          # Similar to what systemd hardening helper suggests
          CapabilityBoundingSet = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = false;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = "yes";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          # This should allow for hardlinking to torrent client files
          ProtectSystem = "full";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
      }

      (mkIf (cfg.settings.sessionSecretFile != null) {
        environment.${envName "sessionSecretFile"} = mkForce "%d/sessionSecretFile";
        serviceConfig.LoadCredential = "sessionSecretFile:${cfg.settings.sessionSecretFile}";
      })
    ];

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };

    users = {
      users = mkIf (cfg.user == "qui") {
        qui = {
          inherit (cfg) group;
          description = "qui user";
          isSystemUser = true;
        };
      };

      groups = mkIf (cfg.group == "qui") { qui = { }; };
    };
  };

  meta.maintainers = with maintainers; [
    connor-grady
    undefined-landmark
  ];
}
