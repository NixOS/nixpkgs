{
  lib,
  stdenv,
  flutter324,
  protoc-gen-prost,
  rustPlatform,
  alsa-lib,
  fetchFromGitHub,
  replaceVars,
  pkg-config,
  openssl,
  dbus,
  libnotify,
  libayatana-appindicator,
  protobuf_26,
  protoc-gen-dart,
}:
let
  pname = "rune-player";
  version = "1.1.0";

  metaCommon = {
    description = "Experience timeless melodies with a music player that blends classic design with modern technology";
    homepage = "https://github.com/Losses/rune";
    license = with lib.licenses; [
      mpl20
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ aucub ];
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    macos_secure_bookmarks = "sha256-qC3Ytxkg5bGh6rns0Z/hG3uLYf0Qyw6y6Hq+da1Je0I=";
    fluent_ui = "sha256-r40uN7mwr6MCNg41AKdk2Z9Zd4pUCxV0xwLXKgNauqo=";
    scrollable_positioned_list = "sha256-tkRlxnmyG5r5yZwEvj9KDfEf4OuSM0HEwPOYm7T7LnQ=";
    system_tray = "sha256-1XMVu1uHy4ZgPKDqfQ7VTDVJvDxky5+/BbocGz8rKYs=";
  };

  src = flutter324.buildFlutterApplication {
    inherit
      pname
      version
      pubspecLock
      gitHashes
      ;

    src = fetchFromGitHub {
      owner = "Losses";
      repo = "rune";
      tag = "v${version}";
      hash = "sha256-vYbi6vguKPI7UoCIKjlGHTQi+OoVjPbIOLNyoW2DOv0=";
    };

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

      cp -r . $out
      mkdir $debug

      runHook postInstall
    '';

    meta = metaCommon;
  };

  libhub = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "libhub";

    useFetchCargoVendor = true;

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

    doCheck = false; # test failed

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

  buildInputs = [
    libnotify
    libayatana-appindicator
  ];

  customSourceBuilders = {
    rinf =
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
  };

  postInstall = ''
    mkdir -p $out/share/icons
    cp -r assets/icons/gnome $out/share/icons/hicolor
    install -Dm0644 assets/source/linux/rune.desktop $out/share/applications/rune-player.desktop
  '';

  meta = metaCommon // {
    mainProgram = "rune";
  };
}
