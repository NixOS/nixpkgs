{
  lib,
  rustdesk-flutter,
  flutter329,
  fetchFromGitHub,
  rustPlatform,
  libdrmtap,
  libglvnd,
  addDriverRunpath,
  systemd,
  procps,
  coreutils,
  findutils,
  util-linux,
  getent,
  gawk,
  gnugrep,
  gnused,
  which,
  xdg-utils,
  xdg-user-dirs,
  testers,
}:

rustdesk-flutter.override {
  inherit flutter329;
  buildFlutterApplication =
    previousAttrs:
    flutter329.buildFlutterApplication (
      finalAttrs:
      previousAttrs
      // {
        # The DRM capture and display-wake features are not in a stable release yet.
        version = "1.4.9-unstable-2026-09-08";
        __structuredAttrs = true;

        src = fetchFromGitHub {
          owner = "rustdesk";
          repo = "rustdesk";
          rev = "22b1ed169aa473b320e338c546f1f7b9a511f23f";
          fetchSubmodules = true;
          hash = "sha256-Qt5KLbXvA6WB+tX+l0keZBQo1K0HFMJbP8URiqUQ3z8=";
        };

        sourceRoot = "${finalAttrs.src.name}/flutter";

        # Resolved with Flutter 3.29.3, including extended_text 15 for its selection API.
        pubspecLock = lib.importJSON ./pubspec.lock.json;
        gitHashes = lib.importJSON ./git-hashes.json;
        # Nix ignores the Dart builder's passAsFile with structured attributes.
        pubspecLockFilePath = ./pubspec.lock.json;

        cargoDeps = rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src;
          hash = "sha256-GTFAfVwcWtEz5ViPWRbInTvZbOM8jS/aD9cAxVhKsfw=";
        };

        cargoBuildFeatures = previousAttrs.cargoBuildFeatures ++ [
          "drm"
          "drm-wake"
        ];

        patches = previousAttrs.patches ++ [ ./reenter-wrapper.patch ];

        postPatch = ''
          # Root must load the capture library from a trusted absolute path.
          substituteInPlace libs/scrap/src/common/drmtap_dl.rs \
            --replace-fail '/usr/lib/rustdesk/libdrmtap.so.0' '${lib.getLib libdrmtap}/lib/libdrmtap.so.0'
          substituteInPlace src/platform/linux.rs \
            --replace-fail '@rustdesk-wrapper@' '${placeholder "out"}/bin/rustdesk'
          substituteInPlace flutter/pubspec.yaml \
            --replace-fail 'extended_text: 14.0.0' 'extended_text: 15.0.2'
        ''
        + previousAttrs.postPatch;

        # Prefer the host's setuid wrappers on NixOS; elsewhere sudo/su are found
        # through the inherited PATH. Store sudo/su binaries are not setuid.
        extraWrapProgramArgs = ''
          --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]} \
          --prefix PATH : /run/wrappers/bin:${
            lib.makeBinPath [
              systemd
              procps
              coreutils
              findutils
              util-linux
              getent
              gawk
              gnugrep
              gnused
              which
              xdg-utils
              xdg-user-dirs
            ]
          }
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck

          rustLibrary="$out/app/$pname/lib/librustdesk.so"
          test -x "$out/bin/rustdesk"
          grep -aFq '${lib.getLib libdrmtap}/lib/libdrmtap.so.0' "$rustLibrary"
          grep -aFq 'enable-drm-display-wake' "$rustLibrary"
          grep -aFq "$out/bin/rustdesk" "$rustLibrary"
          if grep -aFq '/usr/lib/rustdesk/libdrmtap.so.0' "$rustLibrary"; then
            echo 'Unpatched DRM loader path in RustDesk' >&2
            exit 1
          fi

          runHook postInstallCheck
        '';

        passthru = (previousAttrs.passthru or { }) // {
          tests.version = testers.testVersion {
            package = finalAttrs.finalPackage;
            # Upstream identifies the development version as 1.5.0.
            version = "1.5.0";
          };
        };

        meta = previousAttrs.meta // {
          description = "Remote desktop client with unattended Wayland support";
          changelog = "https://github.com/rustdesk/rustdesk/compare/1.4.9...${finalAttrs.src.rev}";
          maintainers = with lib.maintainers; [ telometto ];
        };
      }
    );
}
