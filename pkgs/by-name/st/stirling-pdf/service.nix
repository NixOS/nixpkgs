# Non-module dependencies (`callPackage`)
{
  which,
  unpaper,
  libreoffice,
  qpdf,
  ocrmypdf,
  poppler-utils,
  unoserver,
  pngquant,
  tesseract,
  python3,
  ghostscript_headless,
  imagemagick,
  calibre,
  runCommand,
  makeBinaryWrapper,
  ...
}:

{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.stirling-pdf;
in
{
  _class = "service";

  options.stirling-pdf = {
    package = lib.mkOption {
      description = "Package to use for stirling-pdf";
      defaultText = "The stirling-pdf package that provided this module.";
      type = lib.types.package;
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

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = "The finalPackage used by the service, constructed from `package`.";
    };
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.stateDir = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "stirling-pdf";
      example = "stirling-pdf";
      description = "Name of the systemd state directory.";
    };

    systemd.user = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "stirling-pdf";
      example = "stirling-pdf";
      description = "Name of the systemd user.";
    };
  };

  config = lib.mkMerge [
    {
      stirling-pdf.finalPackage =
        let
          # following https://docs.stirlingpdf.com/Installation/Unix%20Installation
          path = lib.makeBinPath (
            [
              # `which` is used to test command availability
              # See https://github.com/Stirling-Tools/Stirling-PDF/blob/main/app/core/src/main/java/stirling/software/SPDF/config/ExternalAppDepConfig.java#L262
              which
              unpaper
              libreoffice
              qpdf
              ocrmypdf
              poppler-utils
              unoserver
              pngquant
              tesseract
              (python3.withPackages (
                p: with p; [
                  weasyprint
                  opencv-python-headless
                ]
              ))
              ghostscript_headless
              imagemagick
            ]
            ++ lib.optional (cfg.environment.INSTALL_BOOK_AND_ADVANCED_HTML_OPS or "false" == "true") calibre
          );
        in
        runCommand "stirling-pdf"
          {
            nativeBuildInputs = [ makeBinaryWrapper ];
            inherit (cfg.package) meta;
          }
          ''
            makeWrapper \
              "${lib.getExe cfg.package}" "$out/bin/${cfg.package.meta.mainProgram}" \
              --prefix PATH : ${path} \
              ${
                lib.concatMapAttrsStringSep " " (name: value: "--set ${name} ${toString value}") cfg.environment
              } \
              ${lib.pipe cfg.environmentFiles [
                (builtins.map (name: "--run '. ${name}'"))
                (lib.concatStringsSep "\n")
              ]}
          '';
      process.argv = [
        (lib.getExe cfg.finalPackage)
      ];
    }
    # TODO
    # deplyoment targets
    # - nixos systemd service
    # - oci containers w/ nimi
    # - nix run w/ nimi
    # - systemd user service
    #   - home manager service
    # - sysm service
    # - nod service
    #   - For this service I don't know if it makes sense (too heavy and libreoffice drv can work on android?)
    # - nix-darwin service
    #   - For this I honestly don't care because I can't get access to free macos to improve their situation
    #   - For this service I don't know if it makes sense (libreoffice drv can work on macos?)
    # - systemd-nspawn containers
    #
    # - secret management for all above scenarios
    (lib.optionalAttrs (options ? systemd) {
      systemd.service = {
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          # NOTE: from redlib pr, to make it use process.argv?
          # also systemd.mainExecStart is an option
          ExecStart = lib.mkBefore [ "" ];

          BindReadOnlyPaths = [ "${tesseract}/share/tessdata:/usr/share/tessdata" ];

          Environment = [ "HOME=%S/${cfg.systemd.stateDir}" ];
          CacheDirectory = cfg.systemd.stateDir;
          RuntimeDirectory = cfg.systemd.stateDir;
          StateDirectory = cfg.systemd.stateDir;
          WorkingDirectory = "%S/${cfg.systemd.stateDir}";

          SuccessExitStatus = 143;
          User = cfg.systemd.user;

          # Hardening
          CapabilityBoundingSet = "";
          DynamicUser = true;
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
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
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @clock @setuid @chown"
          ];
          UMask = "0077";
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [
    DCsunset
    timhae
  ];
}
