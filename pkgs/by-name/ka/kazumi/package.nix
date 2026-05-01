{
  lib,
  stdenv,
  flutter338,
  fetchFromGitHub,
  autoPatchelfHook,
  alsa-lib,
  gst_all_1,
  libayatana-appindicator,
  mimalloc,
  mpv-unwrapped,
  webkitgtk_4_1,
  _experimental-update-script-combinators,
  nix-update-script,
  runCommand,
  yq-go,
  dart,
}:

let
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "Kazumi";
    tag = version;
    hash = "sha256-KcZh8T6tf81/bAJj2ZMNynfHWGvzrwxwj0nXbXckJhY=";
  };
in
flutter338.buildFlutterApplication {
  pname = "kazumi";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

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

          cp -r . "$out"

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
          sed -i '/if(ARCH_NAME STREQUAL "x86_64")/,/if(MEDIA_KIT_LIBS_AVAILABLE)/{ /if(MEDIA_KIT_LIBS_AVAILABLE)/!d; /set(LIBMPV_ZIP_URL/d }' media_kit_video/linux/CMakeLists.txt
          sed -i '/if(MEDIA_KIT_LIBS_AVAILABLE)/i \
            set(LIBMPV_UNZIP_DIR "${mpv-unwrapped}/lib")\n\
            set(LIBMPV_PATH "${mpv-unwrapped}/lib")\n\
            set(LIBMPV_HEADER_UNZIP_DIR "${mpv-unwrapped.dev}/include/mpv")' media_kit_video/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp -r . "$out"

          runHook postInstall
        '';
      };
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    alsa-lib
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    libayatana-appindicator
    mpv-unwrapped
    webkitgtk_4_1
  ];

  postInstall = ''
    ln -snf ${mpv-unwrapped}/lib/libmpv.so.2 $out/app/$pname/lib/libmpv.so.2
    install -Dm 0644 assets/linux/io.github.Predidit.Kazumi.desktop -t $out/share/applications/
    install -Dm 0644 assets/images/logo/logo_linux.png $out/share/icons/hicolor/512x512/apps/io.github.Predidit.Kazumi.png
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
        (_experimental-update-script-combinators.copyAttrOutputToFile "kazumi.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Watch Animes online with danmaku support";
    homepage = "https://github.com/Predidit/Kazumi";
    mainProgram = "kazumi";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lonerOrz ];
    platforms = lib.platforms.linux;
  };
}
