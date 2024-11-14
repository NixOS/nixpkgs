{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gotenberg;

  args =
    [
      "--api-port=${toString cfg.port}"
      "--api-timeout=${cfg.timeout}"
      "--api-root-path=${cfg.rootPath}"
      "--log-level=${cfg.logLevel}"
      "--chromium-max-queue-size=${toString cfg.chromium.maxQueueSize}"
      "--libreoffice-restart-after=${toString cfg.libreoffice.restartAfter}"
      "--libreoffice-max-queue-size=${toString cfg.libreoffice.maxQueueSize}"
      "--pdfengines-engines=${lib.concatStringsSep "," cfg.pdfEngines}"
    ]
    ++ optional cfg.enableBasicAuth "--api-enable-basic-auth"
    ++ optional cfg.chromium.autoStart "--chromium-auto-start"
    ++ optional cfg.chromium.disableJavascript "--chromium-disable-javascript"
    ++ optional cfg.chromium.disableRoutes "--chromium-disable-routes"
    ++ optional cfg.libreoffice.autoStart "--libreoffice-auto-start"
    ++ optional cfg.libreoffice.disableRoutes "--libreoffice-disable-routes";

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    optional
    optionalAttrs
    ;
in
{
  options = {
    services.gotenberg = {
      enable = mkEnableOption "Gotenberg, a stateless API for PDF files";

      # Users can override only gotenberg, libreoffice and chromium if they want to (eg. ungoogled-chromium, different LO version, etc)
      # Don't allow setting the qpdf, pdftk, or unoconv paths, as those are very stable
      # and there's only one version of each.
      package = mkPackageOption pkgs "gotenberg" { };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Port on which the API should listen.";
      };

      timeout = mkOption {
        type = types.nullOr types.str;
        default = "30s";
        description = "Timeout for API requests.";
      };

      rootPath = mkOption {
        type = types.str;
        default = "/";
        description = "Root path for the Gotenberg API.";
      };

      enableBasicAuth = mkOption {
        type = types.bool;
        default = false;
        description = ''
          HTTP Basic Authentication.

          If you set this, be sure to set `GOTENBERG_API_BASIC_AUTH_USERNAME`and `GOTENBERG_API_BASIC_AUTH_PASSWORD`
          in your `services.gotenberg.environmentFile` file.
        '';
      };

      extraFontPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Extra fonts to make available.";
      };

      chromium = {
        package = mkPackageOption pkgs "chromium" { };

        maxQueueSize = mkOption {
          type = types.int;
          default = 0;
          description = "Maximum queue size for chromium-based conversions. Setting to 0 disables the limit.";
        };

        autoStart = mkOption {
          type = types.bool;
          default = false;
          description = "Automatically start chromium when Gotenberg starts. If false, Chromium will start on the first conversion request that uses it.";
        };

        disableJavascript = mkOption {
          type = types.bool;
          default = false;
          description = "Disable Javascript execution.";
        };

        disableRoutes = mkOption {
          type = types.bool;
          default = false;
          description = "Disable all routes allowing Chromium-based conversion.";
        };
      };

      libreoffice = {
        package = mkPackageOption pkgs "libreoffice" { };

        restartAfter = mkOption {
          type = types.int;
          default = 10;
          description = "Restart LibreOffice after this many conversions. Setting to 0 disables this feature.";
        };

        maxQueueSize = mkOption {
          type = types.int;
          default = 0;
          description = "Maximum queue size for LibreOffice-based conversions. Setting to 0 disables the limit.";
        };

        autoStart = mkOption {
          type = types.bool;
          default = false;
          description = "Automatically start LibreOffice when Gotenberg starts. If false, Chromium will start on the first conversion request that uses it.";
        };

        disableRoutes = mkOption {
          type = types.bool;
          default = false;
          description = "Disable all routes allowing LibreOffice-based conversion.";
        };
      };

      pdfEngines = mkOption {
        type = types.listOf (
          types.enum [
            "pdftk"
            "qpdf"
            "libreoffice-pdfengine"
            "exiftool"
            "pdfcpu"
          ]
        );
        default = [
          "pdftk"
          "qpdf"
          "libreoffice-pdfengine"
          "exiftool"
          "pdfcpu"
        ];
        description = ''
          PDF engines to enable. Each one can be used to perform a specific task.
          See [the documentation](https://gotenberg.dev/docs/configuration#pdf-engines) for more details.
          Defaults to all possible PDF engines.
        '';
      };

      logLevel = mkOption {
        type = types.enum [
          "error"
          "warn"
          "info"
          "debug"
        ];
        default = "info";
        description = "The logging level for Gotenberg.";
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Environment file to load extra environment variables from.";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Any extra command-line flags to pass to the Gotenberg service.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enableBasicAuth -> cfg.environmentFile != null;
        message = ''
          When enabling HTTP Basic Authentication with `services.gotenberg.enableBasicAuth`,
          you must provide an environment file via `services.gotenberg.environmentFile` with the appropriate environment variables set in it.

          See `services.gotenberg.enableBasicAuth` for the names of those variables.
        '';
      }
    ];

    systemd.services.gotenberg = {
      description = "Gotenberg API server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      environment = {
        LIBREOFFICE_BIN_PATH = "${cfg.libreoffice.package}/lib/libreoffice/program/soffice.bin";
        CHROMIUM_BIN_PATH = lib.getExe cfg.chromium.package;
        FONTCONFIG_FILE = pkgs.makeFontsConf {
          fontDirectories = [ pkgs.liberation_ttf_v2 ] ++ cfg.extraFontPackages;
        };
      };
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArgs args}";

        # Hardening options
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateUsers = true;

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";

        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;

        LockPersonality = true;
        MemoryDenyWriteExecute = true;

        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallArchitectures = "native";

        UMask = 77;
      } // optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; };
    };
  };

  meta.maintainers = with lib.maintainers; [ pyrox0 ];
}
