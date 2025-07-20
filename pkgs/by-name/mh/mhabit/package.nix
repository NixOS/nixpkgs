{
  lib,
  fetchFromGitHub,
  flutter324,
  sqlite,
  libsecret,
}:

flutter324.buildFlutterApplication rec {
  pname = "mhabit";
  version = "1.16.22+91";

  src = fetchFromGitHub {
    owner = "FriesI23";
    repo = "mhabit";
    tag = "v${version}";
    hash = "sha256-OEbUAOpEly5PohUD8smSNfMHoReti/4TSKNvEekjyXo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes.icon_font_generator = "sha256-QmChsa2qP+gZyZ2IrJMrY/zBP/J5QigidjIHahp3V0g=";

  postPatch = ''
    substituteInPlace pubspec.yaml \
      --replace-fail "generate: true" "generate: false"
  '';

  preBuild = ''
    substituteInPlace pubspec.yaml \
      --replace-fail "generate: false" "generate: true"
  '';

  buildInputs = [
    sqlite
    libsecret
  ];

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
  };
}
