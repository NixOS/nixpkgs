{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.suwayomi-server;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkPackageOption
    types
    ;

  format = pkgs.formats.hocon { };
  configFile = format.generate "server.conf" (
    lib.pipe cfg.settings [
      (
        settings:
        lib.recursiveUpdate settings {
          server.basicAuthEnabled = null;
          server.basicAuthUsername = null;
          server.basicAuthPasswordFile = null;
          server.authPasswordFile = null;
          server.authPassword =
            if (settings.server.authMode == "basic_auth" || settings.server.authMode == "simple_login") then
              "$TACHIDESK_SERVER_AUTH_PASSWORD"
            else
              null;
        }
      )
      (lib.filterAttrsRecursive (_: x: x != null))
    ]
  );
  isAtLeast2611 = lib.versionAtLeast config.system.stateVersion "26.11";

  serverDir = if isAtLeast2611 then cfg.dataDir else "${cfg.dataDir}/.local/share/Tachidesk";
  serverConf =
    if isAtLeast2611 then
      "${cfg.dataDir}/server.conf"
    else
      "${cfg.dataDir}/.local/share/Tachidesk/server.conf";
in
{
  imports = [
    (lib.mkChangedOptionModule
      [ "services" "suwayomi-server" "settings" "server" "basicAuthEnabled" ]
      [ "services" "suwayomi-server" "settings" "server" "authMode" ]
      (
        config:
        let
          isEnabled = lib.getAttrFromPath [
            "services"
            "suwayomi-server"
            "settings"
            "server"
            "basicAuthEnabled"
          ] config;
        in
        if isEnabled then "basic_auth" else "none"
      )
    )
  ];

  options = {
    services.suwayomi-server = {
      enable = mkEnableOption "Suwayomi, a free and open source manga reader server that runs extensions built for Tachiyomi";

      package = mkPackageOption pkgs "suwayomi-server" { };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/suwayomi-server";
        example = "/var/data/mangas";
        description = ''
          The path to the data directory in which Suwayomi-Server will download scans.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "suwayomi";
        example = "root";
        description = ''
          User account under which Suwayomi-Server runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "suwayomi";
        example = "medias";
        description = ''
          Group under which Suwayomi-Server runs.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for the port in {option}`services.suwayomi-server.settings.server.port`.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          imports = [
            (lib.mkRenamedOptionModule [ "server" "basicAuthUsername" ] [ "server" "authUsername" ])
            (lib.mkRenamedOptionModule [ "server" "basicAuthPasswordFile" ] [ "server" "authPasswordFile" ])
          ];
          freeformType = format.type;
          options = {
            server = {
              ip = mkOption {
                type = types.str;
                default = "0.0.0.0";
                example = "127.0.0.1";
                description = ''
                  The ip that Suwayomi will bind to.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 8080;
                example = 4567;
                description = ''
                  The port that Suwayomi will listen to.
                '';
              };

              webUIEnabled = mkOption {
                type = types.bool;
                default = true;
                example = false;
                description = ''
                  Should suwayomi-server serve a the webui package?
                '';
              };

              webUIFlavor = mkOption {
                type = types.enum [
                  "Custom"
                  "WebUI"
                ];
                default = "Custom";
                example = "WebUI";
                description = ''
                  Choose "Custom" to use the nix package of suwayomi-webui, and
                  "WebUI" to let suwayomi-server to download the WebUI.
                '';
              };

              kcefEnabled = mkOption {
                type = types.bool;
                default = true;
                example = false;
                description = ''
                  Whether to enable KCEF WebView provider.
                '';
              };

              authMode = mkOption {
                type = types.enum [
                  "none"
                  "basic_auth"
                  "simple_login"
                  "ui_auth"
                ];
                default = "none";
                description = ''
                  The auth mode to use when authenticating with the server.
                  See <https://github.com/Suwayomi/Suwayomi-Server/blob/master/docs/Configuring-Suwayomi%E2%80%90Server.md#authentication>
                  for more information.
                '';
              };

              authUsername = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  The username value that you have to provide when authenticating.
                '';
              };

              # NOTE: this is not a real upstream option
              authPasswordFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                example = "/var/secrets/suwayomi-server-password";
                description = ''
                  The password file containing the value that you have to provide when authenticating.
                '';
              };

              downloadAsCbz = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Download chapters as `.cbz` files.
                '';
              };

              extensionStores = mkOption {
                type = types.listOf types.str;
                default = [ ];
                example = [
                  "https://github.com/MY_ACCOUNT/MY_REPO/raw/repo/index.pb"
                ];
                description = ''
                  URLs of the extension store indexes from which extensions can be
                  installed.
                '';
              };

              localSourcePath = mkOption {
                type = types.path;
                default = cfg.dataDir;
                defaultText = lib.literalExpression "suwayomi-server.dataDir";
                example = "/var/data/local_mangas";
                description = ''
                  Path to the local source folder.
                '';
              };

              systemTrayEnabled = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether to enable a system tray icon, if possible.
                '';
              };
            };
          };
        };
        description = ''
          Configuration to write to {file}`server.conf`.
          See <https://github.com/Suwayomi/Suwayomi-Server/wiki/Configuring-Suwayomi-Server> for more information.
        '';
        default = { };
        example = {
          server.socksProxyEnabled = true;
          server.socksProxyHost = "yourproxyhost.com";
          server.socksProxyPort = "8080";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion =
          with cfg.settings.server;
          (authMode == "basic_auth" || authMode == "simple_login")
          -> (authUsername != null && authPasswordFile != null);
        message = ''
          [suwayomi-server]: the username and the password file cannot be null when the basic auth is enabled
        '';
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.server.port ];

    users.groups = mkIf (cfg.group == "suwayomi") {
      suwayomi = { };
    };

    users.users = mkIf (cfg.user == "suwayomi") {
      suwayomi = {
        group = cfg.group;
        home = cfg.dataDir;
        description = "Suwayomi Daemon user";
        isSystemUser = true;
      };
    };

    systemd.tmpfiles.settings = mkIf (!isAtLeast2611) {
      "10-suwayomi-server" = {
        "${serverDir}".d = {
          mode = "0700";
          inherit (cfg) user group;
        };
      };
    };

    systemd.services.suwayomi-server = {
      description = "A free and open source manga reader server that runs extensions built for Tachiyomi.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = mkIf isAtLeast2611 {
        JAVA_TOOL_OPTIONS = "-Dsuwayomi.tachidesk.config.server.rootDir=${cfg.dataDir}";
      };

      preStart = ''
        # Patch Jetbrains JCEF
        kcefDir=${serverDir}/bin/kcef
        rm -rf $kcefDir
        mkdir -p $kcefDir
        ln -fs ${pkgs.jetbrains.jdk-21}/lib/openjdk/lib $kcefDir
        ln -fs ${pkgs.jetbrains.jdk-21}/lib/openjdk/release $kcefDir/release
      ''
      + (lib.optionalString cfg.settings.server.webUIEnabled ''
        rm -fr ${serverDir}/webUI
        cp -a ${cfg.package.suwayomi-webui} ${serverDir}/webUI
        chmod u+rwX -R ${serverDir}
      '');

      script = ''
        [[ -f ${serverConf} ]] && rm ${serverConf}
        ${lib.optionalString
          (cfg.settings.server.authMode == "basic_auth" || cfg.settings.server.authMode == "simple_login")
          ''
            export TACHIDESK_SERVER_AUTH_PASSWORD="$(cat "$CREDENTIALS_DIRECTORY/TACHIDESK_SERVER_AUTH_PASSWORD")"
          ''
        }
        ${lib.getExe pkgs.envsubst} -i ${configFile} -o ${serverConf}

        exec ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";

        User = cfg.user;
        Group = cfg.group;

        StateDirectory = mkIf (cfg.dataDir == "/var/lib/suwayomi-server") "suwayomi-server";
        LoadCredential =
          mkIf
            (cfg.settings.server.authMode == "basic_auth" || cfg.settings.server.authMode == "simple_login")
            [
              "TACHIDESK_SERVER_AUTH_PASSWORD:${cfg.settings.server.authPasswordFile}"
            ];

        CapabilityBoundingSet = "";
        SystemCallFilter = [ "@system-service" ];

        ReadOnlyPaths = [ configFile ];
        ReadWritePaths = [ cfg.dataDir ];
        NoNewPrivileges = true;
        ProtectClock = true;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        # Java limitations don't allow the
        # following hardening option
        # MemoryDenyWriteExecute = true;
        ProtectHostname = true;

        ProtectSystem = "strict";
        PrivateTmp = true;
        ProtectHome = true;
        PrivateDevices = true;
        ProtectControlGroups = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
    doc = ./suwayomi-server.md;
  };
}
