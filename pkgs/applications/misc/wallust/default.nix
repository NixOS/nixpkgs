{ lib
, fetchFromGitea
, rustPlatform
, nix-update-script
}:
let
  version = "2.9.0";
in
rustPlatform.buildRustPackage {
  pname = "wallust";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = version;
    hash = "sha256-AuZRt02bFr7GzI7qe4giGgjlXK/WX+gmF4+QwD0ChXk=";
  };

  cargoHash = "sha256-O9w18ae83mgF3zjk0WUMeu16Ap7CF2ubuPnOqeCt4Nw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onemoresuza iynaix ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    mainProgram = "wallust";
  };
}
