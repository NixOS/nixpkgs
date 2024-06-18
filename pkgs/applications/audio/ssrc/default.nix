{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ssrc";
  version = "1.33";

  src = fetchFromGitHub {
    owner = "shibatch";
    repo = "SSRC";
    rev = "4adf75116dfc0ef709fef74a0e2f3360bd15007f";
    sha256 = "0hgma66v7sszkpz5jkyscj0q6lmjfqdwf1hw57535c012pa2vdrh";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ssrc ssrc_hp $out/bin
    '';

  meta = with lib; {
    description = "High quality audio sampling rate converter";
    longDescription = ''
      This program converts sampling rates of PCM wav files. This
      program also has a function to apply dither to its output and
      extend perceived dynamic range.

      Sampling rates of 44.1kHz and 48kHz are popularly used, but the
      ratio between these two frequencies is 147:160, which are not
      small numbers. As a result, sampling rate conversion without
      degradation of sound quality requires filter with very large
      order, and it is difficult to have both quality and speed. This
      program quickly converts between these sampling frequencies
      without audible degradation.
    '';

    version = version;
    homepage = "https://shibatch.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ leenaars];
    platforms = platforms.linux;
  };
}
