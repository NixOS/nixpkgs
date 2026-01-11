{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmrfrs";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "trinhminhtriet";
    repo = "rmrfrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1QF1l6V6YmKDPqlbXpMeWg3Pt5AonBHelD63mJkSWNM=";
  };

  cargoHash = "sha256-mPQN/JN6b9/1xo1JSj0LpVjb7rGTwrfU0PY7pbENdg4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful filesystem cleaning tool designed to optimize storage by identifying and removing unnecessary files within known project structures";
    homepage = "https://github.com/trinhminhtriet/rmrfrs";
    downloadPage = "https://github.com/trinhminhtriet/rmrfrs";
    changelog = "https://github.com/trinhminhtriet/rmrfrs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "rmrfrs";
    platforms = with lib.platforms; windows ++ darwin ++ linux;
  };
})
