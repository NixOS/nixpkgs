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
      url = "https://downloads.cursor.com/production/e50823e9ded15fddfd743c7122b4724130c25df8/linux/x64/Cursor-1.4.3-x86_64.AppImage";
      hash = "sha256-bzfOin6riP0h19E1qrx3BtUj1YoKMQtBVd7YN8xAXRA=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/e50823e9ded15fddfd743c7122b4724130c25df8/linux/arm64/Cursor-1.4.3-aarch64.AppImage";
      hash = "sha256-BrlCxRdOFeFb5FrPlkmLktFs/MQZujzqe8fh62SuDOg=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/e50823e9ded15fddfd743c7122b4724130c25df8/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-2biABgjNcV0wY2NYowoiXrDirBz+AanH7UgR8+KNlTw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/e50823e9ded15fddfd743c7122b4724130c25df8/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-ETZIxNzxGdSXHmMYq5ywnnGtdRt6c0Nzh6LMGSUja+c=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "1.4.3";
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
