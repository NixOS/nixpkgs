{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "nix-check-deps";
  version = "0-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "LordGrimmauld";
    repo = "nix-check-deps";
    rev = "263701905ec40a19c52d23d0fdceb1126e20c99e";
    hash = "sha256-RaPk8Cd5ovskxFFvFd0+auIopCo1YHyH+6199qK+d18=";
  };

  cargoHash = "sha256-1fazKGz3PtyTvcIW+PY/LwYc6JlErSO9ZFisTUXJdhc=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Scan nix packages for unused buildInputs";
    homepage = "https://github.com/LordGrimmauld/nix-check-deps";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "nix-check-deps";
    platforms = lib.platforms.unix;
  };
}
