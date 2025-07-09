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
      url = "https://downloads.cursor.com/production/031e7e0ff1e2eda9c1a0f5df67d44053b059c5df/linux/x64/Cursor-1.2.1-x86_64.AppImage";
      hash = "sha256-2rOs5+85crKO/N9dCQLFfUXTfP9JVVR1s/g0bK2E78s=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/031e7e0ff1e2eda9c1a0f5df67d44053b059c5df/linux/arm64/Cursor-1.2.1-aarch64.AppImage";
      hash = "sha256-Otg+NyW1DmrqIb0xqZCfJ4ys61/DBOQNgaAR8PMOCfg=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/031e7e0ff1e2eda9c1a0f5df67d44053b059c5df/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-Rh1erFG7UtGwO1NaM5+tq17mI5WdIX750pIzeO9AK+Q=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/031e7e0ff1e2eda9c1a0f5df67d44053b059c5df/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-k/j3hJnHIdtfK9+T0aq2gFkRM+JulDt4FpU7n4HGEYM=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "1.2.1";
  pname = "cursor";

  # You can find the current VSCode version in the About dialog:
  # workbench.action.showAboutDialog (Help: About)
  vscodeVersion = "1.96.2";

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
    ] ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };
}).overrideAttrs
  (oldAttrs: {
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [ ])
      ++ lib.optionals hostPlatform.isDarwin [ undmg ];

    preInstall =
      (oldAttrs.preInstall or "")
      + lib.optionalString hostPlatform.isLinux ''
        mkdir -p bin
        ln -s ../cursor bin/cursor
      '';

    passthru = (oldAttrs.passthru or { }) // {
      inherit sources;
    };
  })
