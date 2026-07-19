{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkPackageOption
    mkOption
    maintainers
    optionals
    ;
  inherit (lib.types)
    addCheck
    bool
    listOf
    package
    port
    str
    submodule
    ;
  inherit (pkgs)
    symlinkJoin
    makeWrapper
    ;

  cfg = config.services.navidrome;
  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    services.navidrome = {

      enable = mkEnableOption "Navidrome music server";

      package = mkPackageOption pkgs "navidrome" { };

      adminWrapper = mkOption {
        type = bool;
        default = true;
        example = false;
        description = ''
          Add a wrapped Navidrome to PATH for CLI admin tasks.
          This wrapped Navidrome will be called "navidrome-cli".
        '';
      };

      plugins = mkOption {
        type = listOf (
          addCheck package (p: p.isNavidromePlugin or false)
          // {
            name = "navidrome plugin";
            description = "package that is a navidrome plugin";
          }
        );
        default = [ ];
        description = "List of Navidrome plugins";
        example = literalExpression ''
          with pkgs.navidromePlugins; [
            listenbrainz-daily-playlist
          ];
        '';
      };

      finalPackage = mkOption {
        type = package;
        readOnly = true;
        default = cfg.package.override {
          inherit (cfg) plugins;
        };
        defaultText = literalExpression ''
          config.services.navidrome.package.override {
            inherit (config.services.navidrome) plugins;
          }
        '';
        description = "The final navidrome package including all selected plugins.";
      };

      settings = mkOption {
        type = submodule {
          freeformType = settingsFormat.type;

          options = {
            Address = mkOption {
              default = "127.0.0.1";
              description = "Address to run Navidrome on.";
              type = str;
            };

            Port = mkOption {
              default = 4533;
              description = "Port to run Navidrome on.";
              type = port;
            };

            EnableInsightsCollector = mkOption {
              default = false;
              description = "Enable anonymous usage data collection, see <https://www.navidrome.org/docs/getting-started/insights/> for details.";
              type = bool;
            };

            Plugins = {
              Enabled = mkOption {
                default = true;
                description = ''
                  Enable plugin support in navidrome.
                '';
              };
              Folder = mkOption {
                default = "${cfg.finalPackage}/share/plugins";
                description = ''
                  The folder containing navidrome plugins.

                  This directory is automatically created from plugins defined in {option}`services.navidrome.plugins`.
                '';
                readOnly = true;
                type = str;
                defaultText = literalExpression "\"\${config.services.navidrome.finalPackage}/share/plugins\"";
              };
            };
          };
        };
        default = { };
        example = {
          MusicFolder = "/mnt/music";
        };
        description = "Configuration for Navidrome, see <https://www.navidrome.org/docs/usage/configuration-options/> for supported values.";
      };

      user = mkOption {
        type = str;
        default = "navidrome";
        description = "User under which Navidrome runs.";
      };

      group = mkOption {
        type = str;
        default = "navidrome";
        description = "Group under which Navidrome runs.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Whether to open the TCP port in the firewall";
      };

      environmentFile = mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Environment file, used to set any secret ND_* environment variables.";
      };
    };
  };

  config =
    let
      inherit (lib) mkIf optional getExe;
      WorkingDirectory = "/var/lib/navidrome";

      settingsFile = settingsFormat.generate "navidrome.json" cfg.settings;

      # Wrapper so that users can do admin tasks with the configured navidrome
      wrappedNavi = symlinkJoin {
        inherit (cfg.finalPackage) pname version;

        paths = [
          cfg.finalPackage
        ];

        strictDeps = true;
        __structuredAttrs = true;

        nativeBuildInputs = [
          makeWrapper
        ];

        wrapperArgs = [
          "--add-flag"
          "--configfile"
          "--add-flag"
          "${settingsFile}"
        ]
        ++ optionals (cfg.environmentFile != null) [
          "--run"
          "source ${cfg.environmentFile}"
        ];

        postBuild = ''
          makeWrapper "${lib.getExe cfg.finalPackage}" "$out/bin/navidrome-cli" \
            "''${wrapperArgs[@]}"

          rm "$out/bin/navidrome"
        '';

        meta = cfg.finalPackage.meta // {
          mainProgram = "navidrome-cli";
        };
      };
    in
    mkIf cfg.enable {
      systemd = {
        tmpfiles.settings.navidromeDirs = {
          "${cfg.settings.DataFolder or WorkingDirectory}"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
          "${cfg.settings.CacheFolder or (WorkingDirectory + "/cache")}"."d" = {
            mode = "700";
            inherit (cfg) user group;
          };
          "${cfg.settings.MusicFolder or (WorkingDirectory + "/music")}"."d" = {
            mode = ":700";
            user = ":${cfg.user}";
            group = ":${cfg.group}";
          };
        };
        services.navidrome = {
          description = "Navidrome Media Server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe cfg.finalPackage} --configfile ${settingsFile}";
            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "navidrome";
            inherit WorkingDirectory;
            RuntimeDirectory = "navidrome";
            RootDirectory = "/run/navidrome";
            ReadWritePaths = "";
            BindPaths =
              optional (cfg.settings ? DataFolder) cfg.settings.DataFolder
              ++ optional (cfg.settings ? CacheFolder) cfg.settings.CacheFolder
              ++ optional (cfg.settings ? Backup.Path) cfg.settings.Backup.Path;
            BindReadOnlyPaths = [
              # navidrome uses online services to download additional album metadata / covers
              "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
              builtins.storeDir
              "/etc"
            ]
            ++ optional (cfg.settings ? MusicFolder) cfg.settings.MusicFolder
            ++ lib.optionals config.services.resolved.enable [
              "/run/systemd/resolve/stub-resolv.conf"
              "/run/systemd/resolve/resolv.conf"
            ];
            CapabilityBoundingSet = "";
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            PrivateDevices = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            RestrictRealtime = true;
            LockPersonality = true;
            # 0.60.0 Taglib introduces WASM JIT that requires this
            MemoryDenyWriteExecute = false;
            UMask = "0066";
            ProtectHostname = true;
          };
        };
      };

      users.users = mkIf (cfg.user == "navidrome") {
        navidrome = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      users.groups = mkIf (cfg.group == "navidrome") { navidrome = { }; };

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.Port ];

      environment.systemPackages = mkIf cfg.adminWrapper [
        wrappedNavi
      ];
    };
  meta.maintainers = with maintainers; [
    fsnkty
    tebriel
  ];
}
