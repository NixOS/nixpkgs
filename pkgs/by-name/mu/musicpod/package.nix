{
  lib,
  stdenv,
  flutter341,
  fetchFromGitHub,
  alsa-lib,
  mimalloc,
  mpv-unwrapped,
  libass,
  libnotify,
  pulseaudio,
  runCommand,
  _experimental-update-script-combinators,
  yq-go,
  nix-update-script,
  dart,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "musicpod";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "ubuntu-flutter-community";
    repo = "musicpod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-riBBJXeSsCi3i0+aKnGElIbhQdvkpvIqMdu4FB3veFU=";
  };

  customSourceBuilders = {
    # unofficial media_kit_libs_linux
    media_kit_libs_linux =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "media_kit_libs_linux";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          sed -i '/set(MIMALLOC "mimalloc-/,/add_custom_target/d' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
          sed -i '/set(PLUGIN_NAME "media_kit_libs_linux_plugin")/i add_custom_target("MIMALLOC_TARGET" ALL DEPENDS ${mimalloc}/lib/mimalloc.o)' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          cp --recursive . "$out"

          runHook postInstall
        '';
      };
    # unofficial media_kit_video
    media_kit_video =
      { version, src, ... }:
      stdenv.mkDerivation {
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

          cp --recursive . "$out"

          runHook postInstall
        '';
      };
  };

  postPatch = ''
    substituteInPlace snap/gui/musicpod.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/musicpod.png' 'Icon=musicpod'
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  buildInputs = [
    alsa-lib
    mpv-unwrapped
    libass
    libnotify
  ];

  runtimeDependencies = [ pulseaudio ];

  postInstall = ''
    ln --symbolic --no-dereference --force ${mpv-unwrapped}/lib/libmpv.so.2 $out/app/$pname/lib/libmpv.so.2
    install -Dm644 snap/gui/musicpod.desktop -t $out/share/applications
    install -Dm644 snap/gui/musicpod.png -t $out/share/icons/hicolor/256x256/apps
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq-go ];
          inherit (finalAttrs) src;
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "musicpod.pubspecSource" ./pubspec.lock.json)
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
    description = "Music, radio, television and podcast player";
    homepage = "https://github.com/ubuntu-flutter-community/musicpod";
    license = lib.licenses.gpl3Only;
    mainProgram = "musicpod";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
