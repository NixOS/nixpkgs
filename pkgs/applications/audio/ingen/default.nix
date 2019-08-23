{ stdenv, fetchgit, boost, ganv, glibmm, gtkmm2, libjack2, lilv
, lv2Unstable, makeWrapper, pkgconfig, python, raul, rdflib, serd, sord, sratom
, wafHook
, suil
}:

stdenv.mkDerivation  rec {
  name = "ingen-unstable-${rev}";
  rev = "2017-07-22";

  src = fetchgit {
    url = "https://git.drobilla.net/cgit.cgi/ingen.git";
    rev = "cc4a4db33f4d126a07a4a498e053c5fb9a883be3";
    sha256 = "1gmwmml486r9zq4w65v91mfaz36af9zzyjkmi74m8qmh67ffqn3w";
    deepClone = true;
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [
    boost ganv glibmm gtkmm2 libjack2 lilv lv2Unstable makeWrapper
    python raul serd sord sratom suil
  ];

  preConfigure = ''
    sed -e "s@{PYTHONDIR}/'@out/'@" -i wscript
  '';

  propagatedBuildInputs = [ rdflib ];

  postInstall = ''
    for program in ingenams ingenish
    do
      wrapProgram $out/bin/$program \
        --prefix PYTHONPATH : $out/${python.sitePackages}:$PYTHONPATH
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
