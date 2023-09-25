{ lib
, fetchFromGitea
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wallust";
  version = "2.7.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = pname;
    rev = version;
    hash = "sha256-WhL2HWM1onRrCqWJPLnAVMd/f/xfLrK3mU8jFSLFjAM=";
  };

  cargoSha256 = "sha256-pR2vdqMGJZ6zvXwwKUIPjb/lWzVgYqQ7C7/sk/+usc4= ";

  meta = with lib; {
    description = "A better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza iynaix ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    platforms = platforms.unix;
    mainProgram = "wallust";
  };
}
