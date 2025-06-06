{
  pkgs,
  config,
  lib,
  ...
}:
let
  emptySource = pkgs.runCommand "empty-source" { } ''
    mkdir $out
  '';
  desktopItem = pkgs.makeDesktopItem {
    name = "mailspring";
    desktopName = "Mailspring";
    genericName = "Email Client";
    exec = "mailspring";
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "Email"
    ];
    icon = "mailspring";
  };

  wrapPackage =
    { settings }:
    pkgs.stdenv.mkDerivation rec {
      pname = "mailspring";
      version = lib.getVersion pkgs.mailspring;
      executable = pkgs.writeShellScript "mailspring.sh" ''
        EXECUTABLE=${lib.getExe pkgs.mailspring}
        FLAGS=${
          lib.concatStringsSep " " (
            [ ]
            ++ lib.optional (settings.password-store != null) "--password-store=${settings.password-store}"
            ++ lib.optional (settings.dev != null) "--dev=${toString settings.dev}"
            ++ lib.optional (settings.log-file != null) "--log-file=${settings.log-file}"
            ++ lib.optional (settings.background != null) "--background=${toString settings.background}"
            ++ lib.optional (settings.safe != null) "--safe=${toString settings.safe}"
          )
        }

        if [ "$#" -gt 0 ]; then
          $EXECUTABLE "$@"
        else
          $EXECUTABLE $FLAGS
        fi
      '';
      src = emptySource;
      nativeBuildInputs = [ pkgs.copyDesktopItems ];
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share
        install -Dm755 ${executable} -T $out/bin/mailspring
        cp -r ${pkgs.mailspring}/share/icons $out/share
        cp -r ${desktopItem}/* $out/
        runHook postInstall
      '';

      desktopItems = [ "share/applications/mailspring.desktop" ];
    };
in
{
  options.programs.mailspring = {
    enable = lib.mkEnableOption "Mailspring E-Mail client";

    settings.password-store = lib.mkOption {
      type = lib.types.enum [
        "basic"
        "gnome-keyring"
        "gnome-libsecret"
        "kwallet"
        "kwallet5"
        "kwallet6"
        "pass"
      ];
      description = "e.g. kwallet6 or gnome-libsecret";
    };

    settings.log-file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Log all test output to file";
    };

    settings.dev = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Run in development mode";
    };

    settings.background = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Start Mailspring in the background";
    };

    settings.safe = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = "Do not load packages from the settings 'packages' or 'dev/packages' folders.";
    };
  };

  config = lib.mkIf config.programs.mailspring.enable {
    environment.systemPackages = with config.programs.mailspring; [
      (wrapPackage { inherit settings; })
    ];
  };

  meta.maintainers = with lib.maintainers; [
    relief-melone
  ];
}
