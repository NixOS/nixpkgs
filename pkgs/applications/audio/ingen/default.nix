{ stdenv, fetchsvn, boost, ganv, glibmm, gtk, gtkmm, libjack2, lilv-svn
, lv2, makeWrapper, pkgconfig, python, raul, rdflib, serd, sord-svn, sratom
, suil
}:

stdenv.mkDerivation  rec {
  name = "ingen-svn-${rev}";
  rev = "5769";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/ingen";
    rev = rev;
    sha256 = "1d7kp2b0jsbfg6c3cs9fiyd0k3d8y0k4qwzp51pvwv8g0dgnkg6f";
  };

  buildInputs = [
    boost ganv glibmm gtk gtkmm libjack2 lilv-svn lv2 makeWrapper pkgconfig
    python raul serd sord-svn sratom suil
  ];

  configurePhase = ''
    sed -e "s@{PYTHONDIR}/'@out/'@" -i wscript
    python waf configure --prefix=$out
  '';

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
