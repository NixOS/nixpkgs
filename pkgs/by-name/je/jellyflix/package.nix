{
  lib,
  stdenv,
  flutter332,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  mpv-unwrapped,
}:
flutter332.buildFlutterApplication rec {
  pname = "jellyflix";
  version = "1.4.886";

  src = fetchFromGitHub {
    owner = "jellyflix-app";
    repo = "jellyflix";
    tag = version;
    hash = "sha256-1kQIHUHDRKuJbqrYo40vjmcxSTPEi5uVUSi2MCKk6qA=";
  };
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postPatch = ''
    substituteInPlace lib/services/api_service.dart \
      --replace-fail "} on DioException catch (_) {
          return _.response!.statusCode ?? 400;" "} on DioException catch (e) {
          return e.response!.statusCode ?? 400;"

    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "-Werror" ""
  '';

  postInstall = ''
    install -Dm644 $src/assets/icon/icon.png $out/share/icons/hicolor/scalable/apps/jellyflix.png
  '';

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    mpv-unwrapped
  ];

  customSourceBuilders = {
    volume_controller =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "volume_controller";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          substituteInPlace linux/CMakeLists.txt \
            --replace-fail '# ALSA dependency for volume control' 'find_package(PkgConfig REQUIRED)' \
            --replace-fail 'find_package(ALSA REQUIRED)' 'pkg_check_modules(ALSA REQUIRED alsa)'
        '';

        installPhase = ''
          runHook preInstall

          mkdir $out
          cp -r ./* $out/

          runHook postInstall
        '';
      };
  };

  gitHashes =
    let
      media_kit-hash = "sha256-8dIiEeeBQOGST9kGHSp15Cdg377AQeBynbvWPAnGbJc=";
    in
    {
      filter_list = "sha256-cYnsujNMC6n9hZNHcbOevXWh54+jPeuHEUbdt1mDgP8=";
      tentacle = "sha256-30a4Vn8wL0TdboSYPm1W+hRqXSsuID0gNOVnNe3KmPE=";
      media_kit = media_kit-hash;
      media_kit_video = media_kit-hash;
      media_kit_libs_video = media_kit-hash;
      media_kit_libs_android_video = media_kit-hash;
      media_kit_libs_ios_video = media_kit-hash;
      media_kit_libs_macos_video = media_kit-hash;
      media_kit_libs_windows_video = media_kit-hash;
    };

  desktopItems = [
    (makeDesktopItem {
      name = "jellyflix";
      desktopName = "Jellyflix";
      genericName = "Media Player";
      exec = "jellyflix";
      icon = "jellyflix";
    })
  ];

  meta = {
    description = "Easy-to-use Jellyfin client for movies and shows";
    homepage = "https://github.com/jellyflix-app/jellyflix";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    mainProgram = "jellyflix";
    platforms = lib.platforms.linux;
  };
}
