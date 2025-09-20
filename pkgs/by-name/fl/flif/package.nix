{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libpng,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flif";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "FLIF-hub";
    repo = "FLIF";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S2RYno5u50jCgu412yMeXxUoyQzeaCqr8U13XC43y8o=";
  };

  postUnpack = ''
    sourceRoot=''${sourceRoot}/src
    echo Source root reset to ''${sourceRoot}
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpng ];

  installPhase = ''
    runHook preInstall

    make install PREFIX=$out
    make install-dev PREFIX=$out

    runHook postInstall
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = {
    description = "Free Lossless Image Format";
    homepage = "https://flif.info";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ leguteape ];
    mainProgram = "flif";
    platforms = lib.platforms.unix;
    longDescription = ''
      A novel lossless image format which outperforms PNG,
      lossless WebP, lossless BPG, lossless JPEG2000,
      and lossless JPEG XR in terms of compression ratio.
    '';
  };
})
