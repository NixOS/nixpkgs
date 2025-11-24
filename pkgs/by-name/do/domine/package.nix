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
    sha256 = "038yfa22q7lzz85czmny3c1lkv8mjv4pq62cbmh054fqvgf3k3s4";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  meta = {
    description = "Instantly search domains with expressions and AI";
    homepage = "https://github.com/breitburg/domine";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "domine";
  };
}
