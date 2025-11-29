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
      url = "https://downloads.cursor.com/production/60d42bed27e5775c43ec0428d8c653c49e58e26a/linux/x64/Cursor-2.1.39-x86_64.AppImage";
      hash = "sha256-SsKhW8q/AzOn1HqykhwaVHyTVm+OqTUiFtda7XDiAho=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/60d42bed27e5775c43ec0428d8c653c49e58e26a/linux/arm64/Cursor-2.1.39-aarch64.AppImage";
      hash = "sha256-m0QNf/ock6hRkOJXqMACBV6mM6/6ZAD6/yues9hGCfU=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/60d42bed27e5775c43ec0428d8c653c49e58e26a/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-kFjKAoRMxRJqBC75LCcbEiwqdunaphj/e2afrFD3NaM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/60d42bed27e5775c43ec0428d8c653c49e58e26a/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-9kP0C7KLLSD0Oak75P/4Qt5sIncTwW6Sldz2/9yi4EE=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "2.1.39";
  pname = "cursor";

  # You can find the current VSCode version in the About dialog:
  # workbench.action.showAboutDialog (Help: About)
  vscodeVersion = "1.105.1";

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
