{ stdenv, fetchurl, cairo, gtk, gtkmm, lv2, lvtk, pkgconfig, python }:

stdenv.mkDerivation  rec {
  name = "ams-lv2-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/blablack/ams-lv2/archive/v${version}.tar.gz";
    sha256 = "0fa1ghf6qahbhj9j1ciyw0hr6nngwksa37hbs651mlz0fn7lz4xm";
  };

  buildInputs = [ cairo gtk gtkmm lv2 lvtk pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "An LV2 port of the internal modules found in Alsa Modular Synth";
    homepage = http://objectivewave.wordpress.com/ams-lv2;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
