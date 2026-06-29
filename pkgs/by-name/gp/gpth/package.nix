{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "gpth";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "TheLastGimbus";
    repo = "GooglePhotosTakeoutHelper";
    tag = "v${version}";
    hash = "sha256-loLwBuonOJH04ujqv2yZJfGYE1k1LF+0O+jYWPrYUKA=";
  };

  dartEntryPoints = {
    "bin/gpth" = "bin/gpth.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    description = "Organizes and cleans up photos retrieved through Google Takeout";
    homepage = "https://github.com/TheLastGimbus/GooglePhotosTakeoutHelper";
    changelog = "https://github.com/TheLastGimbus/GooglePhotosTakeoutHelper/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "gpth";
    maintainers = with lib.maintainers; [ harryfinbow ];
  };
}
