{ stdenv, fetchurl, qt4, jack2, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "0v9zpa49cdj8ixpppgxz95dbn62v8mamxz6fpl7sdnzfn2l8jr4g";
  };

  buildInputs = [ qt4 jack2 lv2 ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = http://synthv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}