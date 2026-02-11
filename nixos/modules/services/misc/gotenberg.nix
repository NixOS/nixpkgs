{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gotenberg;

  args = [
    "--api-port=${toString cfg.port}"
    "--api-timeout=${cfg.timeout}"
    "--api-root-path=${cfg.rootPath}"
    "--log-level=${cfg.logLevel}"
    "--chromium-max-queue-size=${toString cfg.chromium.maxQueueSize}"
    "--libreoffice-restart-after=${toString cfg.libreoffice.restartAfter}"
    "--libreoffice-max-queue-size=${toString cfg.libreoffice.maxQueueSize}"
    "--pdfengines-merge-engines=${lib.concatStringsSep "," cfg.pdfEngines.merge}"
    "--pdfengines-convert-engines=${lib.concatStringsSep "," cfg.pdfEngines.convert}"
    "--pdfengines-read-metadata-engines=${lib.concatStringsSep "," cfg.pdfEngines.readMetadata}"
    "--pdfengines-write-metadata-engines=${lib.concatStringsSep "," cfg.pdfEngines.writeMetadata}"
    "--api-download-from-allow-list=${cfg.downloadFrom.allowList}"
    "--api-download-from-max-retry=${toString cfg.downloadFrom.maxRetries}"
  ]
  ++ optional cfg.enableBasicAuth "--api-enable-basic-auth"
  ++ optional cfg.chromium.autoStart "--chromium-auto-start"
  ++ optional cfg.chromium.disableJavascript "--chromium-disable-javascript"
  ++ optional cfg.chromium.disableRoutes "--chromium-disable-routes"
  ++ optional cfg.libreoffice.autoStart "--libreoffice-auto-start"
  ++ optional cfg.libreoffice.disableRoutes "--libreoffice-disable-routes"
  ++ optional cfg.pdfEngines.disableRoutes "--pdfengines-disable-routes"
  ++ optional (
    cfg.downloadFrom.denyList != null
  ) "--api-download-from-deny-list=${cfg.downloadFrom.denyList}"
  ++ optional cfg.downloadFrom.disable "--api-disable-download-from"
  ++ optional (cfg.bodyLimit != null) "--api-body-limit=${cfg.bodyLimit}"
  ++ lib.optionals (cfg.extraArgs != [ ]) cfg.extraArgs;

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

      bindIP = mkOption {
        type = types.nullOr types.str;
        default = "127.0.0.1";
        description = "Port the API listener should bind to. Set to 0.0.0.0 to listen on all available IPs.";
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

      bodyLimit = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Sets the max limit for `multipart/form-data` requests. Accepts values like '5M', '20G', etc.";
      };

      extraFontPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Extra fonts to make available.";
      };

      chromium = {
        package = mkPackageOption pkgs "chromium" { };

        maxQueueSize = mkOption {
          type = types.ints.unsigned;
          default = 0;
          description = "Maximum queue size for chromium-based conversions. Setting to 0 disables the limit.";
        };

        autoStart = mkOption {
          type = types.bool;
          default = false;
          description = "Automatically start Chromium when Gotenberg starts. If false, Chromium will start on the first conversion request that uses it.";
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

      downloadFrom = {
        allowList = mkOption {
          type = types.nullOr types.str;
          default = ".*";
          description = "Allow these URLs to be used in the `downloadFrom` API field. Accepts a regular expression.";
        };
        denyList = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Deny accepting URLs from these domains in the `downloadFrom` API field. Accepts a regular expression.";
        };
        maxRetries = mkOption {
          type = types.ints.unsigned;
          default = 4;
          description = "The maximum amount of times to retry downloading a file specified with `downloadFrom`.";
        };
        disable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to disable the ability to download files for conversion from outside sources.";
        };
      };

      libreoffice = {
        package = mkPackageOption pkgs "libreoffice" { };

        restartAfter = mkOption {
          type = types.ints.unsigned;
          default = 10;
          description = "Restart LibreOffice after this many conversions. Setting to 0 disables this feature.";
        };

        maxQueueSize = mkOption {
          type = types.ints.unsigned;
          default = 0;
          description = "Maximum queue size for LibreOffice-based conversions. Setting to 0 disables the limit.";
        };

        autoStart = mkOption {
          type = types.bool;
          default = false;
          description = "Automatically start LibreOffice when Gotenberg starts. If false, LibreOffice will start on the first conversion request that uses it.";
        };

        disableRoutes = mkOption {
          type = types.bool;
          default = false;
          description = "Disable all routes allowing LibreOffice-based conversion.";
        };
      };

      pdfEngines = {
        merge = mkOption {
          type = types.listOf (
            types.enum [
              "qpdf"
              "pdfcpu"
              "pdftk"
            ]
          );
          default = [
            "qpdf"
            "pdfcpu"
            "pdftk"
          ];
          description = "PDF Engines to use for merging files.";
        };
        convert = mkOption {
          type = types.listOf (
            types.enum [
              "libreoffice-pdfengine"
            ]
          );
          default = [
            "libreoffice-pdfengine"
          ];
          description = "PDF Engines to use for converting files.";
        };
        readMetadata = mkOption {
          type = types.listOf (
            types.enum [
              "exiftool"
            ]
          );
          default = [
            "exiftool"
          ];
          description = "PDF Engines to use for reading metadata from files.";
        };
        writeMetadata = mkOption {
          type = types.listOf (
            types.enum [
              "exiftool"
            ]
          );
          default = [
            "exiftool"
          ];
          description = "PDF Engines to use for writing metadata to files.";
        };

        disableRoutes = mkOption {
          type = types.bool;
          default = false;
          description = "Disable routes related to PDF engines.";
        };
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
      {
        assertion = !(lib.isList cfg.pdfEngines);
        message = ''
          Setting `services.gotenberg.pdfEngines` to a list is now deprecated.
          Use the new `pdfEngines.mergeEngines`, `pdfEngines.convertEngines`, `pdfEngines.readMetadataEngines`, and `pdfEngines.writeMetadataEngines` settings instead.

          The previous option was using a method that is now deprecated by upstream.
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
        # Needed for LibreOffice to work correctly.
        # https://github.com/NixOS/nixpkgs/issues/349123#issuecomment-2418330936
        HOME = "/run/gotenberg";
      };
      serviceConfig = {
        Type = "simple";
        # NOTE: disable to debug chromium crashes or otherwise no coredump is created and forbidden syscalls are not being logged
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArgs args}";

        # Needed for LibreOffice to work correctly.
        # See above issue comment.
        WorkingDirectory = "/run/gotenberg";
        RuntimeDirectory = "gotenberg";

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

        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;

        LockPersonality = true;

        SystemCallFilter = [
          "@sandbox"
          "@system-service"
          "@chown"
          "@pkey" # required by chromium or it crashes
          "mincore"
        ];
        SystemCallArchitectures = "native";

        UMask = 77;
      }
      // optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; };
    };
  };
}
