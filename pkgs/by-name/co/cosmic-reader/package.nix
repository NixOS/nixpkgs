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
<<<<<<< HEAD
  version = "0-unstable-2025-12-10";
=======
  version = "0-unstable-2025-11-25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
<<<<<<< HEAD
    rev = "4bbbe6ad4346fddbb4b8dccef03f2b96d238c102";
    hash = "sha256-LsnoLpIw1QETB7SK2N4tOrH82MSiDT7WGufE6eCybTU=";
=======
    rev = "8459e02be5bd778d6e06e2f0c4f561f03dd14a85";
    hash = "sha256-R0t+JkSUkDJkvnj3mjDFN3pcpqI0VkuRpgteXqcEH6Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
