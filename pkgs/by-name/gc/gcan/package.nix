{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gcan";
  version = "0.1.0-unstable-2026-06-08";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "applicative-systems";
    repo = "gcan";
    rev = "fef67b1de0d90eb12b64a39948233057bdb92f6a";
    hash = "sha256-v+c1SPvVWHB6W6Tc1Ue/MkHOsg4+eS998KzUM5ujb6Y=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  # gcan shells out to `nix-store` and `nix-collect-garbage` at runtime; these
  # are expected to be on the host. It is meaningless without nix, so we
  # intentionally do not wrap it with a nix on PATH (matching upstream).

  meta = {
    description = "Analyze, filter, and prune Nix GC roots (transitive closure size, age, location)";
    homepage = "https://github.com/applicative-systems/gcan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.unix;
    mainProgram = "gcan";
  };
})
