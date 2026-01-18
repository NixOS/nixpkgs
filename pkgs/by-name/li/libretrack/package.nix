{
  lib,
  fetchFromGitHub,
  flutter329,
  libappindicator,
}:

flutter329.buildFlutterApplication rec {
  pname = "libretrack";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "proninyaroslav";
    repo = "libretrack";
    tag = version;
    hash = "sha256-USZ243M/0SOvlYns66zkhDQCuq+kgEWYdBZN3iBF9SA=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = {
    "receive_sharing_intent" = "sha256-YsvnLOZvYZMyKx3J596Q3/hY2Fn/AFT6nhLTTHdMFOE=";
  };

  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
     --replace-fail 'find_library(APPINDICATOR_LIBRARY NAMES appindicator3)' 'find_library(${libappindicator} NAMES appindicator3)' \
     --replace-fail 'target_link_libraries(''${BINARY_NAME} PRIVATE ''${APPINDICATOR_LIBRARY})' 'target_link_libraries(''${BINARY_NAME} PRIVATE ${libappindicator}/lib/libappindicator3.so)'
  '';

  nativeBuildInputs = [
    libappindicator
  ];

  # https://github.com/juliansteenbakker/flutter_secure_storage/issues/965
  CXXFLAGS = [ "-Wno-deprecated-literal-operator" ];

  postInstall = ''
    substituteInPlace snap/gui/org.proninyaroslav.libretrack.desktop \
      --replace-fail 'Icon=''${SNAP}/meta/gui/libretrack.png' 'Icon=libretrack' \

    install -Dm644 snap/gui/org.proninyaroslav.libretrack.desktop -t $out/share/applications
    install -Dm644 linux/icons/app-icon.svg $out/share/icons/hicolor/scalable/apps/libretrack.svg
  '';

  meta = {
    description = "Private, cross-platform package tracking app";
    homepage = "https://github.com/proninyaroslav/libretrack";
    changelog = "https://github.com/proninyaroslav/libretrack/releases/tag/${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "libretrack";
    platforms = lib.platforms.linux;
  };
}
