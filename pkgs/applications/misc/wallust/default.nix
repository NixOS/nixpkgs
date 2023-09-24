{ lib
, fetchFromGitea
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wallust";
  version = "2.6.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = pname;
    rev = version;
    hash = "sha256-xcsOOA6esvIhzeka8E9OvCT8aXMWWSHO4lNLtaocTSo=";
  };

  cargoSha256 = "sha256-YDIBn2fjlvNTYwMVn/MkID/EMmzz4oLieVgG2R95q4M=";

  meta = with lib; {
    description = "A better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = licenses.mit;
    maintainers = with maintainers; [onemoresuza iynaix];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    platforms = platforms.unix;
    mainProgram = "wallust";
  };
}
