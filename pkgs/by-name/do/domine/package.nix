{
  buildDartApplication,
  fetchFromGitHub,
  lib,
}:

buildDartApplication {
  pname = "domine";
  version = "nightly-2023-08-10";

  src = fetchFromGitHub {
    owner = "breitburg";
    repo = "domine";
    rev = "d99d02b014d009b0201380a21ddaa57696dc77af";
    hash = "sha256-RI853NvYkQJgXUwYfMmWFe1JAxve1s8K+p8eLIRyHg0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    homepage = "https://github.com/breitburg/domine";
    mainProgram = "domine";
    license = lib.licenses.gpl2Only;
  };
}
