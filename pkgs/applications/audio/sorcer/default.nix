{ stdenv, fetchurl, boost, cairomm, cmake, libsndfile, lv2, ntk, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "sorcer-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/harryhaaren/openAV-Sorcer/archive/release-${version}.tar.gz";
    sha256 = "1jkhs2rhn4givac7rlbj8067r7qq6jnj3ixabb346nw7pd6gn1wn";
  };

  buildInputs = [ boost cairomm cmake libsndfile lv2 ntk pkgconfig python ];

  installPhase = ''
    make install
    cp -a ../presets/* "$out/lib/lv2"
  '';

  meta = with stdenv.lib; {
    homepage = http://openavproductions.com/sorcer/;
    description = "A wavetable LV2 plugin synth, targeted at the electronic / dubstep genre";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
