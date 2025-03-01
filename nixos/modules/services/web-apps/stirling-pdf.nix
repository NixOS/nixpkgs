{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.stirling-pdf;
in
{
  options.services.stirling-pdf = {
    enable = lib.mkEnableOption "the stirling-pdf service";

    package = lib.mkPackageOption pkgs "stirling-pdf" { };

    user = lib.mkOption {
      default = "stirling-pdf";
      description = "User stirling-pdf runs as.";
      type = lib.types.str;
    };

    group = lib.mkOption {
      default = "stirling-pdf";
      description = "Group stirling-pdf runs as.";
      type = lib.types.str;
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
        ]
      );
      default = { };
      example = {
        SERVER_PORT = 8080;
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
      };
      description = ''
        Environment variables for the stirling-pdf app.
        See <https://github.com/Stirling-Tools/Stirling-PDF#customisation> for available options.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files containing additional environment variables to pass to Stirling PDF.
        Secrets should be added in environmentFiles instead of environment.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/stirling-pdf";
      description = "Where stirling-pdf stores persistent files";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.mkIf (cfg.user == "stirling-pdf") {
        stirling-pdf = {
          isSystemUser = true;
          home = cfg.dataDir;
          description = "User for running the stirling-pdf service";
          group = cfg.group;
        };
      };
      groups = lib.mkIf (cfg.group == "stirling-pdf") {
        stirling-pdf = { };
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.stirling-pdf = {
      environment = lib.mapAttrs (_: toString) cfg.environment;

      # following https://docs.stirlingpdf.com/Installation/Unix%20Installation
      path =
        with pkgs;
        [
          # `which` is used to test command availability
          # See https://github.com/Stirling-Tools/Stirling-PDF/blob/main/src/main/java/stirling/software/SPDF/config/ExternalAppDepConfig.java#L42
          which
          unpaper
          # Before any invocation to LibreOffice ended up in trying to mkdir
          # /run/user/<uid>/libreoffice-dbus. Since the user is not a logged one and
          # the user not a lingering one, it always failed with a permission denied
          # error.
          # Thus, we use a libreoffice version not verifying Dbus.
          (libreoffice.override { dbusVerify = false; })
          qpdf
          ocrmypdf
          poppler-utils
          unoconv
          pngquant
          tesseract
          (python3.withPackages (
            p: with p; [
              weasyprint
              opencv-python-headless
            ]
          ))
          ghostscript_headless
        ]
        ++ lib.optional (cfg.environment.INSTALL_BOOK_AND_ADVANCED_HTML_OPS or "false" == "true") calibre;

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        BindReadOnlyPaths = [ "${pkgs.tesseract}/share/tessdata:/usr/share/tessdata" ];
        CacheDirectory = "stirling-pdf";
        Environment = [ "HOME=${cfg.dataDir}" ];
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = lib.getExe cfg.package;
        RuntimeDirectory = "stirling-pdf";
        StateDirectory = "stirling-pdf";
        SuccessExitStatus = 143;
        User = cfg.user;
        WorkingDirectory = cfg.dataDir;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "all"; # for libreoffice to work
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ DCsunset ];
}
