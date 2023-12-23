{ lib
, fetchFromGitea
, rustPlatform
, nix-update-script
}:
let
  version = "2.8.0";
in
rustPlatform.buildRustPackage {
  pname = "wallust";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = version;
    hash = "sha256-qX+pU/ovRV7dA35qSA724vV9azz7dMbEyMVBzqS47Ps=";
  };

  cargoHash = "sha256-PAO7qxaKrRKYoC5RElNCylqRzOgvzPyxb6tTzW4jNi4=";

  # temporarily skip tests for args due to a string formatting conflict
  # https://codeberg.org/explosion-mental/wallust/issues/30
  cargoTestFlags = [ "--test config" "--test cache" "--test template" ];

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
