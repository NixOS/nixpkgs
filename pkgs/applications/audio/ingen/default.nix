{ stdenv, fetchgit, boost, ganv, glibmm, gtkmm2, libjack2, lilv
, lv2, makeWrapper, pkgconfig, python, raul, rdflib, serd, sord, sratom
, suil
}:

stdenv.mkDerivation  rec {
  name = "ingen-unstable-${rev}";
  rev = "2016-10-29";

  src = fetchgit {
    url = "http://git.drobilla.net/cgit.cgi/ingen.git";
    rev = "fd147d0b888090bfb897505852c1f25dbdf77e18";
    sha256 = "1qmg79962my82c43vyrv5sxbqci9c7gc2s9bwaaqd0fcf08xcz1z";
  };

  buildInputs = [
    boost ganv glibmm gtkmm2 libjack2 lilv lv2 makeWrapper pkgconfig
    python raul serd sord sratom suil
  ];

  configurePhase = ''
    sed -e "s@{PYTHONDIR}/'@out/'@" -i wscript
    ${python.interpreter} waf configure --prefix=$out
  '';

  propagatedBuildInputs = [ rdflib ];

  buildPhase = "${python.interpreter} waf";

  installPhase = ''
    ${python.interpreter} waf install
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
