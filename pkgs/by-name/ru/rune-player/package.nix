{
  lib,
  stdenv,
  flutter324,
  buildDartApplication,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  pkg-config,
  protobuf_26,
  protoc-gen-prost,
  alsa-lib,
  openssl,
  dbus,
  libnotify,
  libayatana-appindicator,
}:

let
  protoc-gen-dart = buildDartApplication rec {
    pname = "protoc-gen-dart";
    version = "21.1.2"; # newer version cannot generate required files

    src = fetchFromGitHub {
      owner = "google";
      repo = "protobuf.dart";
      tag = "protoc_plugin-v${version}";
      hash = "sha256-luptbRgOtOBapWmyIJ35GqOClpcmDuKSPu3QoDfp2FU=";
    };

    sourceRoot = "${src.name}/protoc_plugin";

    pubspecLock = lib.importJSON ./protoc-gen-dart-pubspec.lock.json;

    meta = {
      description = "Protobuf plugin for generating Dart code";
      mainProgram = "protoc-gen-dart";
      homepage = "https://pub.dev/packages/protoc_plugin";
      license = lib.licenses.bsd3;
    };
  };

  pname = "rune-player";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Losses";
    repo = "rune";
    tag = "v${version}";
    hash = "sha256-vYbi6vguKPI7UoCIKjlGHTQi+OoVjPbIOLNyoW2DOv0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    macos_secure_bookmarks = "sha256-qC3Ytxkg5bGh6rns0Z/hG3uLYf0Qyw6y6Hq+da1Je0I=";
    fluent_ui = "sha256-r40uN7mwr6MCNg41AKdk2Z9Zd4pUCxV0xwLXKgNauqo=";
    scrollable_positioned_list = "sha256-tkRlxnmyG5r5yZwEvj9KDfEf4OuSM0HEwPOYm7T7LnQ=";
    system_tray = "sha256-1XMVu1uHy4ZgPKDqfQ7VTDVJvDxky5+/BbocGz8rKYs=";
  };

  metaCommon = {
    description = "Experience timeless melodies with a music player that blends classic design with modern technology";
    homepage = "https://github.com/Losses/rune";
    license = with lib.licenses; [
      mpl20
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ emaryn ];
  };

  messages = flutter324.buildFlutterApplication {
    inherit
      pname
      version
      src
      pubspecLock
      gitHashes
      ;

    nativeBuildInputs = [
      protobuf_26
      protoc-gen-prost
      protoc-gen-dart
    ];

    buildPhase = ''
      runHook preBuild

      packageRun rinf message

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib $out/native/hub/src
      cp --recursive lib/messages $out/lib/messages
      cp --recursive native/hub/src/messages $out/native/hub/src/messages
      mkdir $debug

      runHook postInstall
    '';

    meta = metaCommon;
  };

  libhub = rustPlatform.buildRustPackage {
    pname = "libhub";
    inherit version src;

    postPatch = ''
      cp --recursive --no-preserve=mode ${messages}/lib/messages lib/messages
      cp --recursive --no-preserve=mode ${messages}/native/hub/src/messages native/hub/src/messages
    '';

    cargoHash = "sha256-+7zUUUpXYKmeCVA+XZLMR1Z41ZIIfHvPTelCCY/UOfI=";

    nativeBuildInputs = [
      pkg-config
      protobuf_26
    ];

    buildInputs = [
      openssl
      alsa-lib
      dbus
    ];

    doCheck = false; # need gpu

    passthru.libraryPath = "lib/libhub.so";

    meta = metaCommon // {
      mainProgram = "rune-cli";
    };
  };
in
flutter324.buildFlutterApplication {
  inherit
    pname
    version
    src
    pubspecLock
    gitHashes
    ;

  nativeBuildInputs = [
    protobuf_26
    protoc-gen-prost
    protoc-gen-dart
  ];

  buildInputs = [
    libnotify
    libayatana-appindicator
  ];

  customSourceBuilders.rinf =
    { version, src, ... }:
    stdenv.mkDerivation {
      pname = "rinf";
      inherit version src;
      inherit (src) passthru;

      patches = [
        (replaceVars ./cargokit.patch {
          output_lib = "${libhub}/${libhub.passthru.libraryPath}";
        })
      ];

      installPhase = ''
        runHook preInstall

        cp -r . $out

        runHook postInstall
      '';
    };

  preBuild = ''
    packageRun rinf message
  '';

  postInstall = ''
    mkdir -p $out/share/icons
    cp -r assets/icons/gnome $out/share/icons/hicolor
    install -Dm0644 assets/source/linux/rune.desktop $out/share/applications/rune-player.desktop
  '';

  passthru = {
    inherit libhub;
  };

  meta = metaCommon // {
    mainProgram = "rune";
  };
}
