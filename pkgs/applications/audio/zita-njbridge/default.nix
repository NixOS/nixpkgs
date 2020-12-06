{ stdenv, fetchurl, libjack2, zita-resampler }:

stdenv.mkDerivation rec {
  version = "0.4.4";
  pname = "zita-njbridge";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1l8rszdjhp0gq7mr54sdgfs6y6cmw11ssmqb1v9yrkrz5rmwzg8j";
  };

  buildInputs = [ libjack2 zita-resampler ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)"
    "SUFFIX=''"
  ];


  meta = with stdenv.lib; {
    description = "command line Jack clients to transmit full quality multichannel audio over a local IP network";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
