{
  lib,
  fetchFromGitHub,
  flutter329,
  sqlite,
  libsecret,
}:

let
  flutter = flutter329;
in
flutter.buildFlutterApplication rec {
  pname = "mhabit";
  version = "1.21.1+120";

  src = fetchFromGitHub {
    owner = "FriesI23";
    repo = "mhabit";
    tag = "v${version}";
    hash = "sha256-ym+xCv7fRwlms2oIvcthyuz53T0LCgigleg1qmLfZVU=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes.icon_font_generator = "sha256-QmChsa2qP+gZyZ2IrJMrY/zBP/J5QigidjIHahp3V0g=";

  buildInputs = [
    sqlite
    libsecret
  ];

  # https://github.com/juliansteenbakker/flutter_secure_storage/issues/965
  CXXFLAGS = [ "-Wno-deprecated-literal-operator" ];

  postInstall = ''
    install -Dm644 flatpak/io.github.friesi23.mhabit.desktop --target-directory=$out/share/applications
    install -Dm644 assets/logo/icon.svg $out/share/icons/hicolor/scalable/io.github.friesi23.mhabit
  '';

  meta = {
    description = "Track micro habits with easy-to-use charts and tools";
    longDescription = ''
      "Table Habit" is an app that helps you establish and track your
      own micro habit. It includes a complete set of growth curves and
      charts to help you build habits more effectively, and keeps your
      data in sync across devices (currently via WebDAV, with more
      options coming soon).
    '';
    homepage = "https://github.com/FriesI23/mhabit";
    changelog = "https://github.com/FriesI23/mhabit/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "mhabit";
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
}
