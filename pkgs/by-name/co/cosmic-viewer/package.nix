{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  cmake,
  nasm,
  libcosmicAppHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-viewer";
  version = "0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-viewer";
    rev = "6c999eb5100353260d481077f1820ef95ee68ea7";
    hash = "sha256-KUfWA6ZZMSnzagFJNlHJoWJTcMP2jTd0j7BYTYKfBF4=";
  };

  cargoHash = "sha256-Ws8ozNY3hwxdkb5g6RuSDyzt3IRk1svm3byXkIpknQE=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  env.VERGEN_GIT_SHA = finalAttrs.src.rev;

  nativeBuildInputs = [
    just
    cmake
    nasm
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  meta = {
    description = "Image viewer for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-viewer";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-viewer";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cosmic ];
  };
})
