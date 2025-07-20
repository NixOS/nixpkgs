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
    rev = "v${version}";
    hash = "sha256-OEbUAOpEly5PohUD8smSNfMHoReti/4TSKNvEekjyXo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes.icon_font_generator = "sha256-QmChsa2qP+gZyZ2IrJMrY/zBP/J5QigidjIHahp3V0g=";

  buildInputs = [
    sqlite
    libsecret
  ];

  meta = {
    description = "An app that helps you form and track micro habits with easy-to-use charts and tools, making it simple to establish healthy habits that stick";
    homepage = "https://github.com/FriesI23/mhabit";
    changelog = "https://github.com/FriesI23/mhabit/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "mhabit";
    platforms = lib.platforms.all;
  };
}
