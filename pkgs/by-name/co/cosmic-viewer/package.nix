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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-viewer";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-k81AVE8KP6bRu4NBtFFmNELiM74bIAbOmAkAIHvfPyM=";
  };

  cargoHash = "sha256-KQUfeVp8I20ie8Nl4izWlSLN26AJEbsgWSDITxAOxLg=";

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
