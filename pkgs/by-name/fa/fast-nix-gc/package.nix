{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fast-nix-gc";
  version = "0.1.0-unstable-2026-09-10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "fast-nix-gc";
    rev = "4225a2de3f3b4f1a680d41ad79214b8a973d087b";
    hash = "sha256-IGiThwVbnJRrWkFXngryoDxa0uPZJnP4fU+dfRWWJxk=";
  };

  cargoHash = "sha256-bHMR29uAAy0lUkqRIxv0GFqCe2ljA/UEsmzVillidkU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  cargoBuildFlags = [
    "-p"
    "fast-nix-gc"
    "-p"
    "fast-nix-optimise"
  ];

  # Each test spawns a GC process with its own rayon pool. Cap the number of
  # threads so parallel tests do not exhaust the sandbox thread limit.
  env.RAYON_NUM_THREADS = 2;

  cargoTestFlags = [
    "-p"
    "fast-nix-gc"
    "-p"
    "fast-nix-common"
    "-p"
    "fast-nix-optimise"
    "-p"
    "fast-nix-gc-proptest"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/fast-nix-gc --help > /dev/null
    $out/bin/fast-nix-optimise --help > /dev/null

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Faster nix-collect-garbage and nix store optimise";
    homepage = "https://github.com/Mic92/fast-nix-gc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivan ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "fast-nix-gc";
  };
})
