{
  lib,
  flutter332,
  fetchFromGitHub,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  jdk17_headless,
}:
let
  # fetch simple-icons directly to avoid cloning with submodules,
  # which would also clone a whole copy of flutter
  simple-icons = fetchFromGitHub (lib.importJSON ./simple-icons.json);
  desktopId = "io.ente.auth";
  flutter = flutter332;
in
flutter.buildFlutterApplication rec {
  pname = "ente-auth";
  version = "4.4.17";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "mobile" ];
    tag = "auth-v${version}";
    hash = "sha256-qnjOrct70TaaO91QBHcbRIkzLZGH6mbpuLAAKE9k/es=";
  };

  sourceRoot = "${src.name}/mobile/apps/auth";

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  customSourceBuilders.ente_strings =
    { version, src, ... }:
    # There currently is no covenient way to setup the flutter SDK outside of apps
    # and we can't move this to the app's own build phase as it would still reference
    # the immutable source variant without the generated l10n files.
    flutter.buildFlutterApplication {
      inherit version src;
      inherit (src) passthru;
      pname = "ente_strings";
      sourceRoot = "${src.name}/mobile/packages/strings";
      pubspecLock = lib.importJSON ./strings.pubspec.lock.json;

      buildPhase = ''
        runHook preBuild

        flutter gen-l10n

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        # The $debug output can't be disabled for buildFlutterApplication.
        # The $out structure must match that of ente-auth to correctly resolve
        # the package as pubspec uses relative paths for workspace packages.
        mkdir -p $debug $out/mobile/{apps/auth,packages}
        rm pubspec.lock
        cp -r . $out/mobile/packages/strings

        runHook postInstall
      '';
    };

  postPatch = ''
    rmdir assets/simple-icons
    ln -s ${simple-icons} assets/simple-icons
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libayatana-appindicator
    # The networking client used by ente-auth (native_dio_adapter)
    # introduces a transitive dependency on Java, which technically
    # is only needed for the Android implementation.
    # Unfortunately, attempts to remove it from the build entirely were
    # unsuccessful.
    jdk17_headless # JDK version used by upstream CI
  ];

  # https://github.com/juliansteenbakker/flutter_secure_storage/issues/965
  CXXFLAGS = [ "-Wno-deprecated-literal-operator" ];

  flutterBuildFlags = [
    # Disable update notifications and auto-update functionality
    "--dart-define=app.flavor=independent"
  ];

  # Based on https://github.com/ente-io/ente/blob/main/auth/linux/packaging/rpm/make_config.yaml
  # and https://github.com/ente-io/ente/blob/main/auth/linux/packaging/enteauth.appdata.xml
  desktopItems = [
    (makeDesktopItem {
      name = desktopId;
      exec = "enteauth";
      icon = "enteauth";
      desktopName = "Ente Auth";
      genericName = "Ente Authentication";
      comment = "Open source 2FA authenticator, with end-to-end encrypted backups";
      categories = [ "Utility" ];
      keywords = [
        "Authentication"
        "2FA"
      ];
      mimeTypes = [ "x-scheme-handler/enteauth" ];
      startupNotify = false;
    })
  ];

  postInstall = ''
    mkdir -p $out/share/pixmaps
    ln -s $out/app/ente-auth/data/flutter_assets/assets/icons/auth-icon.png $out/share/pixmaps/enteauth.png

    install -Dm444 linux/packaging/enteauth.appdata.xml $out/share/metainfo/${desktopId}.metainfo.xml
    substituteInPlace $out/share/metainfo/${desktopId}.metainfo.xml \
      --replace-fail '<id>enteauth</id>' '<id>${desktopId}</id>' \
      --replace-fail 'enteauth.desktop' '${desktopId}.desktop'

    # For backwards compatibility
    ln -s $out/bin/enteauth $out/bin/ente_auth

    # Not required at runtime as it's only used on Android
    rm $out/app/ente-auth/lib/libdartjni.so
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "End-to-end encrypted, cross platform and free app for storing your 2FA codes with cloud backups";
    longDescription = ''
      Ente's 2FA app. An end-to-end encrypted, cross platform and free app for storing your 2FA codes with cloud backups. Works offline. You can even use it without signing up for an account if you don't want the cloud backups or multi-device sync.
    '';
    homepage = "https://ente.io/auth/";
    changelog = "https://github.com/ente-io/ente/releases/tag/auth-v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      niklaskorz
      schnow265
      zi3m5f
      gepbird
    ];
    mainProgram = "enteauth";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
