{
  lib,
  fetchFromGitHub,
  flutter329,
  autoPatchelfHook,
  makeDesktopItem,
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
  runCommand,
  yq,
  oneanime,
  _experimental-update-script-combinators,
  gitUpdater,
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
    };
  };
in
flutter329.buildFlutterApplication rec {
  pname = "oneanime";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "oneAnime";
    tag = version;
    hash = "sha256-VZdqbdKxzfGlS27WUSvSR2x7wU8uYMkWRU9QvxW22uQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes =
    let
      media_kit-hash = "sha256-NTnEmU873mzB9YuD6hhRXKfF1WWGPjqvmvAH5ULayxI=";
    in
    {
      flutter_open_chinese_convert = "sha256-uRPBBB5RUd8fiFaM8dg9Th2tvQYwnbsQrsiDSPMm5kk=";
      media_kit = media_kit-hash;
      media_kit_libs_android_video = media_kit-hash;
      media_kit_libs_ios_video = media_kit-hash;
      media_kit_libs_linux = media_kit-hash;
      media_kit_libs_macos_video = media_kit-hash;
      media_kit_libs_video = media_kit-hash;
      media_kit_libs_windows_video = media_kit-hash;
      media_kit_video = media_kit-hash;
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
    ln -snf ${mpv}/lib/libmpv.so.2 $out/app/oneanime/lib/libmpv.so.2
    install -Dm0644 assets/images/logo/logo_android_2.png  $out/share/pixmaps/oneanime.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (oneanime) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { })
      (_experimental-update-script-combinators.copyAttrOutputToFile "oneanime.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Anime1 third-party client with bullet screen";
    homepage = "https://github.com/Predidit/oneAnime";
    mainProgram = "oneanime";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
