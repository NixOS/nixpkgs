{ stdenv, fetchsvn, boost, ganv, glibmm, gtk, gtkmm, jack2, lilv
, lv2, pkgconfig, python, raul, serd, sord, sratom, suil
}:

stdenv.mkDerivation  rec {
  name = "ingen-svn-${rev}";
  rev = "5464";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/ingen";
    rev = rev;
    sha256 = "1p5rsxwanpj3kj5yai7zqbharj2ldvn78x3p739vkgpr3dinp506";
  };

  buildInputs = [
    boost ganv glibmm gtk gtkmm jack2 lilv lv2 pkgconfig python
    raul serd sord sratom suil
  ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "A modular audio processing system using JACK and LV2 or LADSPA plugins";
    homepage = http://drobilla.net/software/ingen;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
