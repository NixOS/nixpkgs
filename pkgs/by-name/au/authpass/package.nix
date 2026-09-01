{
  lib,
  flutter344,
  fetchFromGitHub,
  writeText,
  pkg-config,
  libsecret,
  keybinder3,
  jdk,
  # OAuth application credentials for the proprietary cloud storage
  # integrations (Dropbox, Google Drive, OneDrive), which are otherwise
  # disabled: upstream does not publish its own credentials. Register your
  # own application with the respective service and use e.g.
  #   authpass.override { dropboxKey = "..."; dropboxSecret = "..."; }
  # Note that the credentials become part of the store path and the binary.
  dropboxKey ? null,
  dropboxSecret ? null,
  googleClientId ? null,
  googleClientSecret ? null,
  microsoftClientId ? null,
  microsoftClientSecret ? null,
}:

let
  # `version:` from authpass/pubspec.yaml, as <appVersion>+<buildNumber>
  appVersion = "1.9.12";
  buildNumber = "166";

  withCloudSecrets = dropboxKey != null || googleClientId != null || microsoftClientId != null;

  toDartString = s: if s == null then "null" else "'${s}'";

  # Same as upstream's lib/env/fdroid.dart, but with cloud storage
  # credentials filled in. featureCloudStorageProprietary defaults to true.
  nixpkgsEnv = writeText "nixpkgs.dart" ''
    import 'package:authpass/env/_base.dart';
    import 'package:authpass/env/env.dart';

    Future<void> main() async => await NixpkgsEnv().start();

    class NixpkgsEnv extends EnvAppBase {
      NixpkgsEnv() : super(EnvType.production);

      @override
      EnvSecrets get secrets => const EnvSecrets(
        analyticsAmplitudeApiKey: null,
        analyticsGoogleAnalyticsId: null,
        analyticsMatomo: null,
        googleClientId: ${toDartString googleClientId},
        googleClientSecret: ${toDartString googleClientSecret},
        dropboxKey: ${toDartString dropboxKey},
        dropboxSecret: ${toDartString dropboxSecret},
        microsoftClientId: ${toDartString microsoftClientId},
        microsoftClientSecret: ${toDartString microsoftClientSecret},
      );

      @override
      bool get featureFetchWebsiteIconEnabledByDefault => false;

      @override
      bool get diacDefaultDisabled => true;
    }
  '';
in
flutter344.buildFlutterApplication (
  rec {
    pname = "authpass";
    # The latest tagged release (v1.9.11) predates the current Flutter tooling
    # in Nixpkgs and no longer builds; upstream development continues on main.
    version = "${appVersion}-unstable-2026-07-27";

    src = fetchFromGitHub {
      owner = "authpass";
      repo = "authpass";
      rev = "d72e563543326b0f50a6b2246299c270d2816f52";
      hash = "sha256-9DJqeb6qi2vPnrSG9MQkG3iFJ1lq/pfEVmB2uK7rv4k=";
      fetchSubmodules = true;
    };

    sourceRoot = "${src.name}/authpass";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = lib.importJSON ./git-hashes.json;

    # The production entrypoint is only available GPG-encrypted (it contains
    # upstream's service credentials). Build the F-Droid flavor instead, which
    # is the upstream-supported entrypoint for third-party distribution:
    # analytics and proprietary cloud integrations are disabled.
    flutterBuildFlags = [
      "-t"
      (if withCloudSecrets then "lib/env/nixpkgs.dart" else "lib/env/fdroid.dart")
      "--dart-define=AUTHPASS_VERSION=${appVersion}"
      "--dart-define=AUTHPASS_BUILD_NUMBER=${buildNumber}"
      "--dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass"
    ];

    __structuredAttrs = true;
    strictDeps = true;

    # buildDartApplication passes the pubspec lock via passAsFile, which Nix
    # ignores under structured attrs, leaving $pubspecLockFilePath empty.
    # Materialize it from .attrs.json instead; this runs before the
    # `ln -sf "$pubspecLockFilePath" pubspec.lock` appended by the builder.
    preConfigure = ''
      jq -r '.pubspecLockFile' "$NIX_ATTRS_JSON_FILE" > "$NIX_BUILD_TOP/pubspec-lock.json"
      pubspecLockFilePath="$NIX_BUILD_TOP/pubspec-lock.json"
    '';

    # buildFlutterApplication's default buildPhase expands $flutterBuildFlags
    # unquoted, which under structured attrs yields only the first list
    # element and would silently drop the -t entrypoint flag above.
    buildPhase = ''
      runHook preBuild

      mkdir -p build/flutter_assets/fonts

      flutter build linux -v --split-debug-info="$debug" "''${flutterBuildFlags[@]}"

      runHook postBuild
    '';

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      # biometric_storage
      libsecret
      # hotkey_manager_linux
      keybinder3
      # jni
      jdk
    ];

    env.JAVA_HOME = "${jdk}/lib/openjdk";

    # The window's app id / WM_CLASS is the program name "authpass", so the
    # desktop file must be installed under that name for window-to-launcher
    # matching (upstream's app.authpass.AuthPass name is for the Flatpak;
    # their .deb also installs it as authpass.desktop).
    postInstall = ''
      install -Dm644 ../metadata/linux/app.authpass.AuthPass.desktop \
        $out/share/applications/authpass.desktop
      install -Dm644 ../metadata/linux/app.authpass.AuthPass.png \
        $out/share/icons/hicolor/512x512/apps/app.authpass.AuthPass.png
    '';

    meta = {
      description = "Password manager based on Flutter, compatible with KeePass (kdbx 3.x/4.x)";
      longDescription = ''
        Password manager based on Flutter, compatible with KeePass
        (kdbx 3.x/4.x). Local files, WebDAV and AuthPass Cloud work out of
        the box. The proprietary cloud storage integrations (Dropbox,
        Google Drive, OneDrive) are disabled by default because upstream
        does not publish its OAuth application credentials; register your
        own and enable them via the override arguments of this package
        (e.g. `authpass.override { dropboxKey = ...; dropboxSecret = ...; }`),
        see the Nixpkgs manual section on AuthPass.
      '';
      homepage = "https://authpass.app/";
      changelog = "https://github.com/authpass/authpass/blob/main/CHANGELOG.md";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ koppor ];
      mainProgram = "authpass";
      platforms = lib.platforms.linux;
    };
  }
  // lib.optionalAttrs withCloudSecrets {
    postPatch = ''
      install -Dm644 ${nixpkgsEnv} lib/env/nixpkgs.dart
    '';
  }
)
