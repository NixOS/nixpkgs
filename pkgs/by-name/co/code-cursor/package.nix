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
      url = "https://downloads.cursor.com/production/8e4da76ad196925accaa169efcae28c45454cce3/linux/x64/Cursor-2.0.43-x86_64.AppImage";
      hash = "sha256-ok+7uBlI9d3a5R5FvMaWlbPM6tX2eCse7jZ7bmlPExY=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/8e4da76ad196925accaa169efcae28c45454cce3/linux/arm64/Cursor-2.0.43-aarch64.AppImage";
      hash = lib.fakeHash; # Unable to fetch, see comment below for meta.broken
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/8e4da76ad196925accaa169efcae28c45454cce3/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-TZtQ69/o2u9EOCVMnjaovkWUv3Hd+rwhT9InlTOCjAQ=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/8e4da76ad196925accaa169efcae28c45454cce3/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-qy5VqFeZ8IpYDzzIvHyu9SQCfuqhHQD/6p69BLWPlfQ=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "2.0.43";
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
    # Unable to fetch the aarch64 Linux AppImage see https://github.com/NixOS/nixpkgs/pull/456882 or https://forum.cursor.com/t/broken-download-link-for-aarch64-appimage-for-version-2-0-34/140048
    broken = stdenv.hostPlatform.system == "aarch64-linux";
  };
}).overrideAttrs
  (oldAttrs: {
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [ ]) ++ lib.optionals hostPlatform.isDarwin [ undmg ];

    passthru = (oldAttrs.passthru or { }) // {
      inherit sources;
    };
  })
