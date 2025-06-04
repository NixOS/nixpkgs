{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (lib.mkChangedOptionModule
      [ "services" "karakeep" "environmentFile" ]
      [ "services" "karakeep" "environmentFiles" ]
      (
        config:
        let
          environmentFile = lib.getAttrFromPath [ "services" "karakeep" "environmentFile" ] config;
        in
        [ environmentFile ]
      )
    )
  ];

  options.services.karakeep = {
    enable = lib.mkEnableOption "Enable the Karakeep service";
    package = lib.mkPackageOption pkgs "karakeep" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "karakeep";
      description = "User to run karakeep-web and karakeep-workers.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "karakeep";
      description = "Group to run karakeep-web and karakeep-workers.";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf str;
        options = {
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 3000;
            description = "Port KaraKeep should use to listen for requests.";
          };
          DATA_DIR = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/karakeep";
            readOnly = true;
          };
          DISABLE_SIGNUPS = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          DISABLE_NEW_RELEASE_CHECK = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
      description = ''
        Environment variables to pass to KaraKeep. This is how most settings
        can be configured.

        See https://docs.karakeep.app/configuration/
      '';
      default = { };
      example = lib.literalExpression ''
        {
          HOST = "0.0.0.0";
          INFERENCE_LANG = "english";
        }
      '';
    };

    environmentFiles = lib.mkOption {
      type = with lib.types; listOf path;
      description = ''
        An list of paths to environment files as defined in
        {manpage}`systemd.exec(5)` that will be used in the web and workers
        services. This is useful for loading private keys.
      '';
      example = [ "/var/lib/karakeep/secrets.env" ];
    };

    browser = {
      enable = lib.mkOption {
        description = ''
          Enable the karakeep-browser service that runs a chromium instance in
          the background with debugging ports exposed. This is necessary for
          certain features like screenshots.
        '';
        type = lib.types.bool;
        default = true;
      };
      port = lib.mkOption {
        description = "The port the browser should run on.";
        type = lib.types.port;
        default = 9222;
      };
      exe = lib.mkOption {
        description = "The browser executable (must be Chrome-like).";
        type = lib.types.str;
        default = "${pkgs.chromium}/bin/chromium";
        defaultText = lib.literalExpression "\${pkgs.chromium}/bin/chromium";
        example = lib.literalExpression "\${pkgs.google-chrome}/bin/google-chrome-stable";
      };
    };

    meilisearch.enable = lib.mkEnableOption ''
      Enable Meilisearch and configure Karakeep to use it. Meilisearch is
      required for text search.

      See [](#module-services-meilisearch) in the NixOS manual.
    '';

  };

  config =
    let
      cfg = config.services.karakeep;
      dataDir = cfg.extraEnvironment.DATA_DIR;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [ cfg.package ];

      users.users.${cfg.user} = lib.mkIf (cfg.user == "karakeep") {
        inherit (cfg) group;
        home = dataDir;
        isSystemUser = true;
      };
      users.groups = lib.mkIf (cfg.group == "karakeep") { karakeep = { }; };

      services.meilisearch.enable = cfg.meilisearch.enable;

      services.karakeep = {
        extraEnvironment = {
          MEILI_ADDR =
            let
              inherit (config.services.meilisearch) listenAddress listenPort;
            in
            lib.mkDefault "http://${listenAddress}:${toString listenPort}";
          BROWSER_WEB_URL = lib.mkDefault "http://127.0.0.1:${toString cfg.browser.port}";
          NEXTAUTH_URL = lib.mkDefault "localhost";
        };

        # add settings.env generated in karakeep-init first to be overridable
        environmentFiles = lib.mkBefore [
          "${dataDir}/settings.env"
        ];
      };

      systemd.tmpfiles.settings."karakeep".${dataDir}.d = { inherit (cfg) user group; };
      systemd.services =
        let
          sharedServiceConfigAttrs = {
            User = cfg.user;
            Group = cfg.group;
            PrivateTmp = true;
            StateDirectory = "karakeep";
            UMask = "0077";
          };
          environment = lib.mapAttrs (
            name: value: if lib.isBool value then lib.boolToString value else toString value
          ) cfg.extraEnvironment;
          EnvironmentFile = cfg.environmentFiles;
        in
        {

          karakeep-init = {
            inherit environment;
            description = "Initialize Karakeep Data";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            path = [ pkgs.openssl ];
            script = ''
              if [ ! -f "$STATE_DIRECTORY/settings.env" ]; then
                cat <<EOF >"$STATE_DIRECTORY/settings.env"
              # Generated by NixOS Karakeep module
              MEILI_MASTER_KEY=$(openssl rand -base64 36)
              NEXTAUTH_SECRET=$(openssl rand -base64 36)
              EOF
              fi

              exec "${cfg.package}/lib/karakeep/migrate"
            '';
            serviceConfig = sharedServiceConfigAttrs // {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };

          karakeep-workers = {
            inherit environment;
            description = "Karakeep Workers";
            wantedBy = [ "multi-user.target" ];
            after = [
              "network.target"
              "karakeep-init.service"
            ];
            partOf = [ "karakeep-web.service" ];
            path = [
              pkgs.monolith
              pkgs.yt-dlp
            ];
            serviceConfig = sharedServiceConfigAttrs // {
              inherit EnvironmentFile;
              ExecStart = "${cfg.package}/lib/karakeep/start-workers";
            };
          };

          karakeep-web = {
            inherit environment;
            description = "Karakeep Web";
            wantedBy = [ "multi-user.target" ];
            after = [
              "network.target"
              "karakeep-init.service"
              "karakeep-workers.service"
            ];
            serviceConfig = sharedServiceConfigAttrs // {
              inherit EnvironmentFile;
              ExecStart = "${cfg.package}/lib/karakeep/start-web";
            };
          };

          karakeep-browser = lib.mkIf cfg.browser.enable {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            partOf = [ "karakeep-web.service" ];
            script = ''
              export HOME="$CACHE_DIRECTORY"
              exec ${cfg.browser.exe} \
                --headless --no-sandbox --disable-gpu --disable-dev-shm-usage \
                --remote-debugging-address=127.0.0.1 \
                --remote-debugging-port=${toString cfg.browser.port} \
                --hide-scrollbars \
                --user-data-dir="$STATE_DIRECTORY"
            '';
            serviceConfig = sharedServiceConfigAttrs // {
              Type = "simple";
              Restart = "on-failure";

              StateDirectory = "karakeep-browser";
              CacheDirectory = "karakeep-browser";

              DevicePolicy = "closed";
              DynamicUser = true;
              LockPersonality = true;
              NoNewPrivileges = true;
              PrivateDevices = true;
              PrivateUsers = true;
              ProtectClock = true;
              ProtectControlGroups = true;
              ProtectHostname = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              ProtectSystem = "strict";
              RestrictNamespaces = true;
              RestrictRealtime = true;
            };
          };
        };
    };

  meta = {
    maintainers = [ lib.maintainers.three ];
  };
}
