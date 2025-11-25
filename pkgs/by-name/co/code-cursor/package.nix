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
      url = "https://downloads.cursor.com/production/ef979b1b43d85eee2a274c25fd62d5502006e425/linux/x64/Cursor-2.1.32-x86_64.AppImage";
      hash = "sha256-CKLUa5qaT8njAyPMRz6+iX9KSYyvNoyLZFZi6wmR4g0=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/ef979b1b43d85eee2a274c25fd62d5502006e425/linux/arm64/Cursor-2.1.32-aarch64.AppImage";
      hash = "sha256-qQV4D+C0+ncPA7i9A5Q1vVLV8XWMb2/DSwOqU0nhkmk=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/ef979b1b43d85eee2a274c25fd62d5502006e425/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-MbW7kTXY+UjMv4FIy3L6Vjm3TXySVoxHlGEA0uad4Uo=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/ef979b1b43d85eee2a274c25fd62d5502006e425/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-CUlx9iUOWP8FfRC0r7CIyYgyVmLd0+aO6doGX2/0Utc=";
    };
  };

  source = sources.${hostPlatform.system};
in
(callPackage vscode-generic rec {
  inherit useVSCodeRipgrep;
  commandLineArgs = finalCommandLineArgs;

  version = "2.1.32";
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
