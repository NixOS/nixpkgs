{
  lib,
  fetchFromGitHub,
  flutter327,
  autoPatchelfHook,
  makeDesktopItem,
  pkg-config,
  copyDesktopItems,
  alsa-lib,
  libepoxy,
  libpulseaudio,
  libdrm,
  libgbm,
  buildGoModule,
  stdenv,
  mpv-unwrapped,
  mpv,
  mimalloc,
}:
let
  libopencc = buildGoModule rec {
    pname = "libopencc";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "Predidit";
      repo = "open_chinese_convert_bridge";
      tag = version;
      hash = "sha256-kC5+rIBOcwn9POvQlKEzuYKKcbhuqVs+pFd4JSFgINQ=";
    };

    vendorHash = "sha256-ADODygC9VRCdeuxnkK4396yBny/ClRUdG3zAujPzpOM=";

    buildPhase = ''
      runHook preBuild

      go build -buildmode=c-shared -o ./libopencc.so

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm0755 ./libopencc.so $out/lib/libopencc.so

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/Predidit/open_chinese_convert_bridge";
      license = with lib.licenses; [ gpl3Plus ];
      maintainers = with lib.maintainers; [ aucub ];
    };
  };
in
flutter327.buildFlutterApplication rec {
  pname = "oneanime";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "oneAnime";
    tag = version;
    hash = "sha256-lRO5JYzzopy69lJ0/4pLf4u93NlYLaghhG4Fuf04f6A=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    flutter_open_chinese_convert = "sha256-uRPBBB5RUd8fiFaM8dg9Th2tvQYwnbsQrsiDSPMm5kk=";
    media_kit = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_android_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_ios_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_linux = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_macos_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_libs_windows_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
    media_kit_video = "sha256-bWS3j4mUdMYfPhzS16z3NZxLTQDrEpDm3dtkzxcdKpQ=";
  };

  customSourceBuilders = {
    # unofficial media_kit_libs_linux
    media_kit_libs_linux =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "media_kit_libs_linux";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          sed -i '/set(MIMALLOC "mimalloc-/,/add_custom_target/d' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
          sed -i '/set(PLUGIN_NAME "media_kit_libs_linux_plugin")/i add_custom_target("MIMALLOC_TARGET" ALL DEPENDS ${mimalloc}/lib/mimalloc.o)' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
    # unofficial media_kit_video
    media_kit_video =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "media_kit_video";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          sed -i '/set(LIBMPV_ZIP_URL/,/if(MEDIA_KIT_LIBS_AVAILABLE)/{//!d; /set(LIBMPV_ZIP_URL/d}' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_HEADER_UNZIP_DIR "${mpv-unwrapped.dev}/include/mpv")' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_PATH "${mpv}/lib")' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_UNZIP_DIR "${mpv}/lib")' media_kit_video/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };

  desktopItems = [
    (makeDesktopItem {
      name = "oneanime";
      exec = "oneanime";
      icon = "oneanime";
      desktopName = "oneAnime";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    libepoxy
    libpulseaudio
    libdrm
    libgbm
    mpv
  ];

  postPatch = ''
    substituteInPlace lib/pages/init_page.dart \
      --replace-fail "lib/opencc.so" "${libopencc}/lib/libopencc.so"
  '';

  postInstall = ''
    install -Dm0644 ./assets/images/logo/logo_android_2.png  $out/share/pixmaps/oneanime.png
  '';

  meta = {
    description = "Anime1 third-party client with bullet screen";
    homepage = "https://github.com/Predidit/oneAnime";
    mainProgram = "oneanime";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
