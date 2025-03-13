{
  lib,
  flutter,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  mpv-unwrapped,
}:
flutter.buildFlutterApplication rec {
  pname = "jellyflix";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jellyflix-app";
    repo = "jellyflix";
    tag = version;
    hash = "sha256-jqMjKpUOcL4hElEWM1mrQaoraZPj0aUNt2hGLw39inc=";
  };
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postInstall = ''
    install -Dm644 $src/assets/icon/icon.png $out/share/icons/hicolor/scalable/apps/jellyflix.png
  '';

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    mpv-unwrapped
  ];

  gitHashes = {
    filter_list = "sha256-/KgFLeoBTC3yq77esDqXwqP97+BcO3msYKki86OJEj0=";
    tentacle = "sha256-30a4Vn8wL0TdboSYPm1W+hRqXSsuID0gNOVnNe3KmPE=";
    media_kit = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
    media_kit_video = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
    media_kit_libs_video = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
    media_kit_libs_android_video = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
    media_kit_libs_ios_video = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
    media_kit_libs_macos_video = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
    media_kit_libs_windows_video = "sha256-7ER60VqnXN1diIg/y8nuJWgX3N0viWBq0g+2FsGEwFM=";
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
