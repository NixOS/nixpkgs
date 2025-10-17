{
  lib,
  stdenv,
  callPackage,
  vscode-generic,
  fetchurl,
  appimageTools,
  undmg,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv) hostPlatform;
  finalCommandLineArgs = "--update=false " + commandLineArgs;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/fe5d1728063e86edeeda5bebd2c8e14bf4d0f96a/linux/x64/Cursor-1.7.38-x86_64.AppImage";
      hash = "sha256-52QJVbXO3CYeL4vVZ249xabS7AoYFDOxKCQ6m3vB+vE=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/fe5d1728063e86edeeda5bebd2c8e14bf4d0f96a/linux/arm64/Cursor-1.7.38-aarch64.AppImage";
      hash = "sha256-4yUjLAiC7wZYYmAnVNUbRuvLBrpAfC/Kb9y/nONtwkM=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/fe5d1728063e86edeeda5bebd2c8e14bf4d0f96a/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-x56I8XaOvFK7GDlfyAHD18DdUwZrKf7hlXAROplqKU0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/fe5d1728063e86edeeda5bebd2c8e14bf4d0f96a/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-14H1jvVmSsywkFm6M3BFLAwUzorehrbVvo9OJo6cEdk=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "1.7.38";
  pname = "cursor";

  # You can find the current VSCode version in the About dialog:
  # workbench.action.showAboutDialog (Help: About)
  vscodeVersion = "1.99.3";

  executableName = "cursor";
  longName = "Cursor";
  shortName = "cursor";
  libraryName = "cursor";
  iconName = "cursor";

  src =
    if hostPlatform.isLinux then
      appimageTools.extract {
        inherit pname version;
        src = source;
      }
    else
      source;

  sourceRoot =
    if hostPlatform.isLinux then "${pname}-${version}-extracted/usr/share/cursor" else "Cursor.app";

  tests = { };

  updateScript = ./update.sh;

  # Editing the `cursor` binary within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because Cursor is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  # Cursor has no wrapper script.
  patchVSCodePath = false;

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    changelog = "https://cursor.com/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      aspauldingcode
      prince213
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ]
    ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };
}).overrideAttrs
  (oldAttrs: {
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [ ]) ++ lib.optionals hostPlatform.isDarwin [ undmg ];

    passthru = (oldAttrs.passthru or { }) // {
      inherit sources;
    };
  })
