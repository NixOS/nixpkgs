{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  fontconfig,
  freetype,
  gumbo,
  harfbuzz,
  jbig2dec,
  lcms2,
  leptonica,
  libjpeg,
  openjpeg,
  tesseract,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-reader";
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "1b030e2f96dc7a141473f87de3cb1f375298589f";
    hash = "sha256-r+QPe7+rvdYm76DLFtOePh9+eIvSbzuqvhe4490ynWk=";
  };

  cargoHash = "sha256-4ofAtZN3FpYwNahinldALbdEJA5lDwa+CUsVIISnSTc=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    gumbo
    harfbuzz
    jbig2dec
    lcms2
    leptonica
    libjpeg
    openjpeg
    tesseract
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

  env.VERGEN_GIT_SHA = finalAttrs.src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "PDF reader for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-reader";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-reader";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cosmic ];
  };
})
