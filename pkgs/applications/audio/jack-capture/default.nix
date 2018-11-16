{ stdenv, fetchurl, libjack2, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  name = "jack_capture-${version}";
  version = "0.9.73";

  src = fetchurl {
    url = "https://archive.notam02.no/arkiv/src/${name}.tar.gz";
    sha256 = "1pji0zdwm3kxjrkbzj7fnxhr8ncrc8pyqnwyrh47fhypgqjv1br1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjack2 libsndfile ];

  buildPhase = "PREFIX=$out make jack_capture";

  installPhase = ''
    mkdir -p $out/bin
    cp jack_capture $out/bin/
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A program for recording soundfiles with jack";
    homepage = http://archive.notam02.no/arkiv/src;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
