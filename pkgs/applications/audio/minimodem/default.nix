{ stdenv, fetchurl, pkgconfig, fftw, fftwSinglePrec, alsaLib, libsndfile, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "0.19";
  pname = "minimodem";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.whence.com/${pname}/${name}.tar.gz";
    sha256 = "003xyqjq59wcjafrdv1b8w34xsn4nvzz51wwd7mqddajh0g4dz4g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fftw fftwSinglePrec alsaLib libsndfile libpulseaudio ];

  meta = {
    description = "General-purpose software audio FSK modem";
    longDescription = ''
    Minimodem is a command-line program which decodes (or generates) audio
    modem tones at any specified baud rate, using various framing protocols. It
    acts a general-purpose software FSK modem, and includes support for various
    standard FSK protocols such as Bell103, Bell202, RTTY, NOAA SAME, and
    Caller-ID.
    '';
    homepage = http://www.whence.com/minimodem/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ relrod ];
  };
}
