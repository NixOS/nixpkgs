{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bchunk";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "hessu";
    repo = "bchunk";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-wFhBRLRwyC7FrGzadbssqLI9/UwfxBmFfOetaFJgsCo=";
  };

  makeFlags = lib.optionals stdenv.cc.isClang [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    install -Dt $out/bin bchunk
    install -Dt $out/share/man/man1 bchunk.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "http://he.fi/bchunk/";
    description = "Program that converts CD images in BIN/CUE format into a set of ISO and CDR tracks";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    mainProgram = "bchunk";
  };
})
