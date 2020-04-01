{ stdenv, fetchurl, alsaLib, libjack2, zita-alsa-pcmi, zita-resampler }:

stdenv.mkDerivation rec {
  name = "zita-ajbridge-0.8.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "1gvk6g6w9rsiib89l0i9myl2cxxfzmcpbg9wdypq6b27l9s5k64j";
  };

  buildInputs = [ alsaLib libjack2 zita-alsa-pcmi zita-resampler ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man/man1"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Connect additional ALSA devices to JACK";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/index.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
