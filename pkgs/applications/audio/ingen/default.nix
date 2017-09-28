{ stdenv, fetchgit, boost, ganv, glibmm, gtkmm2, libjack2, lilv
, lv2, makeWrapper, pkgconfig, python, raul, rdflib, serd, sord, sratom
, suil
}:

stdenv.mkDerivation  rec {
  name = "ingen-unstable-${rev}";
  rev = "2017-01-18";

  src = fetchgit {
    url = "http://git.drobilla.net/cgit.cgi/ingen.git";
    rev = "02ae3e9d8bf3f6a5e844706721aad8c0ac9f4340";
    sha256 = "15s8nrzn68hc2s6iw0zshbz3lfnsq0mr6gflq05xm911b7xbp74k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost ganv glibmm gtkmm2 libjack2 lilv lv2 makeWrapper
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
