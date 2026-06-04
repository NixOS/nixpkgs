# SPDX-FileCopyrightText: 2025 Gergely Nagy
# SPDX-FileContributor: Gergely Nagy
#
# SPDX-License-Identifier: MIT
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) hashString;
  inherit (lib.attrsets) foldlAttrs mapAttrsToList;
  inherit (lib.lists) any;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.options)
    literalExpression
    mkEnableOption
    mkOption
    mkPackageOption
    ;
  inherit (lib.strings)
    concatStringsSep
    hasPrefix
    optionalString
    versionAtLeast
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

  iocaineConfigFile = config: jsonFormat.generate "iocaine.json" config;

  configFiles =
    if cfg.configPaths == null then
      [ config.environment.etc."iocaine/iocaine.json".source ]
    else
      cfg.configPaths;

  hasUDSbind = any (hasPrefix "/") (
    mapAttrsToList (_server: cfg: cfg.bind) (cfg.config.server or { })
  );

  hasFirewall = cfg.config.firewall.enable or false;

  description = "iocaine, the deadliest poison known to AI";
in
{
  options.services.iocaine = {
    enable = mkEnableOption description;

    package = mkPackageOption pkgs "iocaine" { };

    dataDir = mkOption {
      default = "/var/lib/iocaine";
      type = path;
      description = "The data directory for iocaine.";
      example = "/mnt/iocaine";
    };

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

    config = mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = "The configuration for iocaine.";
      example = literalExpression ''
        {
          server.default = {
            bind = "localhost:2137";
            mode = "http";
            use.handler-from = "default";
          };

          handler.default = {
            config = {
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

    configPaths = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = "Configuration paths to run iocaine with. Takes precedence over `config`.";
      example = literalExpression ''
        [
          "/etc/iocaine/iocaine.json"
          ./iocaine.json
        ]
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = versionAtLeast cfg.package.version "3.5.0";
        message = ''
          Unsupported iocaine version: ${cfg.package.version}!

          This module only works with iocaine 3.5.0 and above.
        '';
      }
      {
        assertion = (cfg.config == { } && cfg.configPaths != null) || cfg.configPaths == null;
        message = ''
          `services.iocaine.config` and `services.iocaine.configPaths` are mutually exclusive. Use only one of them!
        '';
      }
    ];

    environment.etc."iocaine/iocaine.json" = mkIf (cfg.enable && cfg.configPaths == null) {
      source = iocaineConfigFile cfg.config;
    };

    systemd.services = mkIf cfg.enable {
      iocaine = {
        inherit description;

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment = {
          HOME = "%S/home";
        }
        // cfg.environment;

        restartTriggers =
          let
            envHash = hashString "sha256" (
              concatStringsSep "\n" (
                foldlAttrs (
                  acc: name: value:
                  acc ++ [ "${name}=\"${value}\"" ]
                ) [ ] cfg.environment
              )
            );
          in
          [
            cfg.package
            envHash
          ]
          ++ configFiles;

        stopIfChanged = false;

        serviceConfig = {
          Type = "notify";
          ExecStart =
            let
              configPaths =
                if cfg.configPaths == null then
                  optionalString (cfg.config != { }) "--config-path /etc/iocaine/iocaine.json"
                else
                  concatStringsSep " " (map (path: "--config-path ${path}") cfg.configPaths);
            in
            "${getExe cfg.package} ${configPaths} start";

          Restart = "on-failure";
          DynamicUser = true;
          UMask = "0077";
          LimitNOFILE = 524288;

          StateDirectory = "iocaine";
          WorkingDirectory = cfg.dataDir;
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
          PrivateUsers = !hasFirewall;

          SystemCallArchitectures = "native";
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = false;
          NoNewPrivileges = true;

          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ]
          ++ (if hasFirewall then [ "AF_NETLINK" ] else [ ]);

          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];

          CapabilityBoundingSet = if hasFirewall then [ "CAP_NET_ADMIN" ] else [ "" ];
          AmbientCapabilities = mkIf hasFirewall [ "CAP_NET_ADMIN" ];
        };
      };

      nginx = mkIf hasUDSbind {
        requires = [ "iocaine.service" ];
        after = [ "iocaine.service" ];
        serviceConfig.SupplementaryGroups = [ "iocaine" ];
      };

      caddy = mkIf hasUDSbind {
        requires = [ "iocaine.service" ];
        after = [ "iocaine.service" ];
        serviceConfig.SupplementaryGroups = [ "iocaine" ];
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ poz ];
  };
}
