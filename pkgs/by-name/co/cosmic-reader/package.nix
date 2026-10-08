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
  version = "0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "481e33f5f1b90679a367bdd9afd74dcc71eee135";
    hash = "sha256-ex99zF+RzsYT5mgeL8MRnXp+z1O3/5vnIS2poJJgUVk=";
  };

  cargoHash = "sha256-DPGpGWzAgdpHp3qzksLtLnfqk+DJsaukdT2ekFFiGaM=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  env.VERGEN_GIT_SHA = finalAttrs.src.rev;

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

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/com.system76.CosmicReader.thumbnailer \
      --replace-fail "TryExec=cosmic-reader" "TryExec=$out/bin/cosmic-reader" \
      --replace-fail "Exec=cosmic-reader" "Exec=$out/bin/cosmic-reader"
  '';

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
