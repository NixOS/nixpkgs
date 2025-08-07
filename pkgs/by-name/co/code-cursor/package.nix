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
      url = "https://downloads.cursor.com/production/54c27320fab08c9f5dd5873f07fca101f7a3e076/linux/x64/Cursor-1.3.9-x86_64.AppImage";
      hash = "sha256-0kkTL6ZCnLxGBQSVoZ7UEOBNtTZVQolVAk/2McCV0Rw=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/54c27320fab08c9f5dd5873f07fca101f7a3e076/linux/arm64/Cursor-1.3.9-aarch64.AppImage";
      hash = "sha256-5g26fm+tpm8xQTutygI20TcUHL08gKlG0uZSHixK2Ao=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/54c27320fab08c9f5dd5873f07fca101f7a3e076/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-IJV35JNpoUybArz2NhvX8IzDUmvzN+GVq/MyDtXgVeI=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/54c27320fab08c9f5dd5873f07fca101f7a3e076/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-TYdv8UKoBtv0WUHWBqJtpG9vHDkEBBPLS/7BZhdxR1M=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "1.3.9";
  pname = "code-cursor";

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
