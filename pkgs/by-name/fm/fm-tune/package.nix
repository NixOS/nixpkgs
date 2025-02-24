{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  liquid-dsp,
  soapysdr,
}:

stdenv.mkDerivation rec {
  pname = "fm-tune";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "fm_tune";
    rev = version;
    hash = "sha256-pwL2G1Ni1Ixw/N0diSoGGIoVrtmF92mWZ5i57OOvkX4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    liquid-dsp
    soapysdr
  ];

  meta = with lib; {
    description = "Find initial calibration offset for SDR devices";
    longDescription = ''
      fm_tune finds the initial offset for calibrating an SDR device. This is
      based a given FM radio station frequency. The offset given by this tool is
      not precise, but can be useful as a starting point for other tools which
      cannot correct for very large errors.
    '';
    homepage = "https://github.com/viraptor/fm_tune";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ viraptor ];
    mainProgram = "fm_tune";
  };
}
