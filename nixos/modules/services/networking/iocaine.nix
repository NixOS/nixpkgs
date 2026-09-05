{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    any
    getExe
    hasPrefix
    mapAttrsToList
    mkIf
    literalExpression
    mkEnableOption
    mkMerge
    mkOption
    mkPackageOption
    optional
    optionals
    ;

  inherit (lib.types)
    attrsOf
    listOf
    nullOr
    path
    str
    ;

  cfg = config.services.iocaine;

  jsonFormat = pkgs.formats.json { };

  hasUDSbind = any (hasPrefix "/") (
    mapAttrsToList (_server: cfg: cfg.bind) (cfg.settings.server or { })
  );

  ifHasSettings = optional (cfg.settings != null);

  description = "iocaine, the deadliest poison known to AI";
in
{
  options.services.iocaine = {
    enable = mkEnableOption description;

    package = mkPackageOption pkgs "iocaine" { };

    environment = mkOption {
      default = { };
      type = attrsOf str;
      description = "Environment variables for iocaine.";
      example = literalExpression ''
        {
          RUST_LOG = "info";
          RUST_BACKTRACE = "1";
        }
      '';
    };

    enableFirewall = mkEnableOption ''
      the nftables-based firewall.
      Overwrites {option}`services.iocaine.settings.firewall.enable`
    '';

    settings = mkOption {
      type = nullOr jsonFormat.type;
      default = null;
      description = ''
        The configuration for iocaine.
        See [the configuration reference](https://iocaine.madhouse-project.org/documentation/3/configuration/)
        for full documentation on the fields.
      '';
      example = literalExpression ''
        {
          server.default = {
            bind = "localhost:2137";
            mode = "http";
            use.handler-from = "default";
          };

          handler.default = {
            settings = {
              "ai-robots-txt-path" = "/etc/iocaine/data/ai.robots.txt-robots.json";
              sources = {
                training-corpus = [
                  "/data/corpus/1984.txt"
                  "/data/corpus/brave-new-world.txt"
                ];
                wordlists = [ "/data/corpus/words.txt" ];
              };
            };
          };
        }
      '';
    };

    extraSettingsPaths = mkOption {
      type = listOf path;
      default = [ ];
      description = "Configuration paths to run iocaine with. Useful for secrets";
      example = literalExpression ''
        [
          "/etc/iocaine/iocaine.json"
          ./iocaine.json
        ]
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."iocaine/iocaine.json" = mkIf (cfg.settings != null) {
      source = jsonFormat.generate "iocaine.json" cfg.settings;
    };

    systemd.services = mkMerge [
      {
        iocaine = {
          inherit description;

          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          environment = {
            HOME = "%S/home";
          }
          // cfg.environment;

          restartTriggers =
            (ifHasSettings config.environment.etc."iocaine/iocaine.json".source) ++ cfg.extraSettingsPaths;

          stopIfChanged = false;

          serviceConfig = {
            Type = "notify";
            ExecStart = toString (
              [
                (getExe cfg.package)
              ]
              ++ (map (path: "--config-path=${path}") (
                (ifHasSettings "/etc/iocaine/iocaine.json") ++ cfg.extraSettingsPaths
              ))
              ++ [ "start" ]
            );

            Restart = "on-failure";
            DynamicUser = true;
            UMask = "0077";
            LimitNOFILE = 524288;

            StateDirectory = "iocaine";
            WorkingDirectory = "%S/iocaine";
            RuntimeDirectory = "iocaine";

            ProtectSystem = "strict";
            ProtectClock = true;
            ProtectHostname = true;
            ProtectProc = "invisible";
            ProtectControlGroups = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectKernelLogs = true;
            ProtectHome = true;

            PrivateTmp = true;
            PrivateDevices = true;
            PrivateUsers = !cfg.enableFirewall;

            SystemCallArchitectures = "native";
            DevicePolicy = "closed";
            LockPersonality = true;
            MemoryDenyWriteExecute = false;
            NoNewPrivileges = true;

            RestrictAddressFamilies =
              (optionals hasUDSbind [
                "AF_INET"
                "AF_INET6"
                "AF_UNIX"
              ])
              ++ (optionals cfg.enableFirewall [ "AF_NETLINK" ]);

            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
              "~@resources"
            ];

            CapabilityBoundingSet = mkIf cfg.enableFirewall [ "CAP_NET_ADMIN" ];
            AmbientCapabilities = mkIf cfg.enableFirewall [ "CAP_NET_ADMIN" ];
          };
        };
      }

      (
        let
          iocaineDep = {
            requires = [ "iocaine.service" ];
            after = [ "iocaine.service" ];
            serviceConfig.SupplementaryGroups = [ "iocaine" ];
          };
        in
        {
          nginx = mkIf (config.services.nginx.enable && hasUDSbind) iocaineDep;
          caddy = mkIf (config.services.caddy.enable && hasUDSbind) iocaineDep;
        }
      )
    ];
  };

  meta = {
    maintainers = with lib.maintainers; [ poz ];
  };
}
