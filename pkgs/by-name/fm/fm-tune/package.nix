{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  liquid-dsp,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fm-tune";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "fm_tune";
    rev = finalAttrs.version;
    hash = "sha256-kjTcg8nvhPgpsopIjYsaIsEszYPh86ilkSXMMk+z3x0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    liquid-dsp
    soapysdr
  ];

  meta = {
    description = "Find initial calibration offset for SDR devices";
    longDescription = ''
      fm_tune finds the initial offset for calibrating an SDR device. This is
      based a given FM radio station frequency. The offset given by this tool is
      not precise, but can be useful as a starting point for other tools which
      cannot correct for very large errors.
    '';
    homepage = "https://github.com/viraptor/fm_tune";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "fm_tune";
  };
})
