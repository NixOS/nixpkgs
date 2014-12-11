{ stdenv, fetchsvn, boost, ganv, glibmm, gtk, gtkmm, jack2, lilv
, lv2, makeWrapper, pkgconfig, python, raul, rdflib, serd, sord, sratom
, suil
}:

stdenv.mkDerivation  rec {
  name = "ingen-svn-${rev}";
  rev = "5490";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/ingen";
    rev = rev;
    sha256 = "09h2mrkzpwzhhyqy21xr7jhfbl82gmqfyj0lzhnjsrab8z56yzk6";
  };

  buildInputs = [
    boost ganv glibmm gtk gtkmm jack2 lilv lv2 makeWrapper pkgconfig
    python raul serd sord sratom suil
  ];

  configurePhase = "python waf configure --prefix=$out";

  propagatedBuildInputs = [ rdflib ];

  buildPhase = "python waf";

  installPhase = ''
    python waf install
    for program in ingenams ingenish
    do
      wrapProgram $out/bin/$program \
        --prefix PYTHONPATH : $out/lib/python${python.majorVersion}/site-packages:$PYTHONPATH
    done
  '';

  meta = with stdenv.lib; {
    description = "A modular audio processing system using JACK and LV2 or LADSPA plugins";
    homepage = http://drobilla.net/software/ingen;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
