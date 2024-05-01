{ targetPlatform, callPackage }:
  if targetPlatform.isDarwin
  then {
    pname = "parsec-bin";
    version = "150_93c";
    url = "https://archive.org/download/20240430150_93C/parsec-macos.pkg";
    hash = "sha256-xTtg0WW9XKN6VNxZzZWQ8ydzdy2XW5ZuHJs1DO2muLY=";
  }
  else {
    pname = "parsec-bin";
    version = "150_93b";
    url = "https://web.archive.org/web/20240329180120/https://builds.parsec.app/package/parsec-linux.deb";
    hash = "sha256-wfsauQMubnGKGfL9c0Zee5g3nn0eEnOFalQNL3d4weE=";
  }
