{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
let
  version = "0.5.0-unstable-2024-07-20";
  lovelyInjector = fetchFromGitHub {
    # Use this fork for the PR in progress (PR #66) (currently pointing 0.5.0.beta-5)
    # https://github.com/ethangreen-dev/lovely-injector/pull/66
    owner = "vgskye";
    repo = "lovely-injector";
    rev = "a5ce6c5188ae71b3908fa3188e3a1b29c565fb65";
    hash = "sha256-UgUgM+HJ0jrRWqIubHcNQNMwDV/ftlpZxyrIn1bs7bI=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lovely-injector";
  inherit version;
  src = lovelyInjector;
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "retour-0.4.0-alpha.2" = "sha256-GtLTjErXJIYXQaOFLfMgXb8N+oyHNXGTBD0UeyvbjrA=";
    };
  };
  # Disable tests, they are broken on my machine
  doCheck = false;
  # lovely-injector depends on nightly features
  RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "Runtime lua injector for games built with LÖVE";
    longDescription = ''
      Lovely is a lua injector which embeds code into a LÖVE 2d game at runtime.
      Unlike executable patchers, mods can be installed, updated, and removed over and over again without requiring a partial or total game reinstallation.
      This is accomplished through in-process lua API detouring and an easy to use (and distribute) patch system.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/ethangreen-dev/lovely-injector";
    downloadPage = "https://github.com/ethangreen-dev/lovely-injector/releases";
    maintainers = [ lib.maintainers.antipatico ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
