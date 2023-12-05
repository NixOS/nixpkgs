{ lib
, fetchFromGitea
, rustPlatform
, nix-update-script
}:
let
  version = "2.7.1";
in
rustPlatform.buildRustPackage {
  pname = "wallust";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = version;
    hash = "sha256-WhL2HWM1onRrCqWJPLnAVMd/f/xfLrK3mU8jFSLFjAM=";
  };

  cargoSha256 = "sha256-pR2vdqMGJZ6zvXwwKUIPjb/lWzVgYqQ7C7/sk/+usc4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onemoresuza iynaix ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    platforms = lib.platforms.unix;
    mainProgram = "wallust";
  };
}
