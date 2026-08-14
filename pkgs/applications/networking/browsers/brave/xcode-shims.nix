{
  lib,
  symlinkJoin,
  writeShellScriptBin,
  apple-sdk,
  developerDir ? apple-sdk,
  xcbuild,
}:
let
  sdkRoot = "${developerDir}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
  sdkPlatform = "${developerDir}/Platforms/MacOSX.platform";
  # From MacOSX.sdk SystemVersion.plist ProductBuildVersion / ProductVersion.
  sdkVersion = "15.5";
  sdkBuildVersion = "24F74";
in
# Chromium's //build/config/apple/sdk_info.py and //build/mac/find_sdk.py
# shell out to xcodebuild/xcrun/xcode-select. Provide nix-friendly shims that
# report apple-sdk / darwin-devtools paths and a plausible Xcode version.
symlinkJoin {
  name = "brave-origin-xcode-shims";
  paths = [
    (writeShellScriptBin "xcodebuild" ''
      set -euo pipefail
      if [ "''${1:-}" = "-version" ]; then
        echo "Xcode 15.3"
        echo "Build version 15E204a"
        exit 0
      fi
      # Fall through to nixpkgs xcbuild for anything else.
      exec "${xcbuild}/bin/xcodebuild" "$@"
    '')
    (writeShellScriptBin "xcrun" ''
      set -euo pipefail

      # Normalize: support both `xcrun --show-sdk-path` and
      # `xcrun -sdk macosx --show-sdk-*` used by sdk_info.py.
      sdk=""
      action=""
      while [ "$#" -gt 0 ]; do
        case "$1" in
          -sdk|--sdk)
            shift
            sdk="''${1:-}"
            shift || true
            ;;
          --show-sdk-path|--show-sdk-version|--show-sdk-platform-path|--show-sdk-build-version)
            action="$1"
            shift
            ;;
          *)
            break
            ;;
        esac
      done

      if [ -n "$action" ]; then
        case "$sdk" in
          ""|macosx|macos|MacOSX) ;;
          *)
            echo "xcrun shim: unsupported sdk '$sdk'" >&2
            exit 1
            ;;
        esac
        case "$action" in
          --show-sdk-path)
            echo "${sdkRoot}"
            exit 0
            ;;
          --show-sdk-version)
            echo "${sdkVersion}"
            exit 0
            ;;
          --show-sdk-platform-path)
            echo "${sdkPlatform}"
            exit 0
            ;;
          --show-sdk-build-version)
            echo "${sdkBuildVersion}"
            exit 0
            ;;
        esac
      fi

      export SDKROOT="''${SDKROOT:-${sdkRoot}}"
      exec "${xcbuild}/bin/xcrun" "$@"
    '')
    (writeShellScriptBin "xcode-select" ''
      set -euo pipefail
      if [ "''${1:-}" = "-p" ] || [ "''${1:-}" = "--print-path" ] || [ "''${1:-}" = "-print-path" ]; then
        echo "${developerDir}"
        exit 0
      fi
      exec "${xcbuild}/bin/xcode-select" "$@"
    '')
  ];
}
