{
  lib,
  stdenv,
  buildGoModule,
  flutter332,
  fetchFromGitHub,
  autoPatchelfHook,
  desktop-file-utils,
  alsa-lib,
  libdrm,
  libepoxy,
  libgbm,
  libpulseaudio,
  mpv-unwrapped,
  mimalloc,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  libopencc = buildGoModule (finalAttrs: {
    pname = "libopencc";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "Predidit";
      repo = "open_chinese_convert_bridge";
      tag = finalAttrs.version;
      hash = "sha256-kC5+rIBOcwn9POvQlKEzuYKKcbhuqVs+pFd4JSFgINQ=";
    };

    vendorHash = "sha256-ADODygC9VRCdeuxnkK4396yBny/ClRUdG3zAujPzpOM=";

    buildPhase = ''
      runHook preBuild

      go build -buildmode=c-shared -o libopencc.so

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -D --mode=0644 libopencc.so --target-directory $out/lib

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/Predidit/open_chinese_convert_bridge";
      license = lib.licenses.gpl3Plus;
    };
  });

  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "oneAnime";
    tag = version;
    hash = "sha256-VZdqbdKxzfGlS27WUSvSR2x7wU8uYMkWRU9QvxW22uQ=";
  };
in
flutter332.buildFlutterApplication {
  pname = "oneanime";
  inherit version src;

  postPatch = ''
    substituteInPlace lib/pages/init_page.dart \
      --replace-fail "lib/opencc.so" "${libopencc}/lib/libopencc.so"
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

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
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_PATH "${mpv-unwrapped}/lib")' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i set(LIBMPV_UNZIP_DIR "${mpv-unwrapped}/lib")' media_kit_video/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };

  nativeBuildInputs = [
    autoPatchelfHook
    desktop-file-utils
  ];

  buildInputs = [
    alsa-lib
    libdrm
    libepoxy
    libgbm
    libpulseaudio
    mpv-unwrapped
  ];

  postInstall = ''
    ln --symbolic --no-dereference --force ${mpv-unwrapped}/lib/libmpv.so.2 $out/app/oneanime/lib/libmpv.so.2
    install -D --mode=0644 assets/images/logo/logo_android_2.png  $out/share/pixmaps/oneanime.png
    desktop-file-edit oneAnime.desktop \
      --set-key="Icon" --set-value="oneanime"
    install -D --mode=0644 oneAnime.desktop --target-directory $out/share/applications
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "oneanime.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Anime1 third-party client with bullet screen";
    homepage = "https://github.com/Predidit/oneAnime";
    mainProgram = "oneanime";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
