{ lib, stdenv, fetchgit, boost, ganv, glibmm, gtkmm2, libjack2, lilv
, lv2, pkg-config, python3, raul, serd, sord, sratom
, waf
, suil
}:

stdenv.mkDerivation  rec {
  pname = "ingen";
  version = "unstable-2019-12-09";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/ingen.git";
    rev = "e32f32a360f2bf8f017ea347b6d1e568c0beaf68";
    sha256 = "0wjn2i3j7jb0bmxymg079xpk4iplb91q0xqqnvnpvyldrr7gawlb";
    deepClone = true;
  };

  nativeBuildInputs = [ pkg-config waf.hook python3 python3.pkgs.wrapPython ];
  buildInputs = [
    boost ganv glibmm gtkmm2 libjack2 lilv lv2
    python3 raul serd sord sratom suil
  ];

  strictDeps = true;

  pythonPath = [
    python3
    python3.pkgs.rdflib
  ];

  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
  '';

  meta = with lib; {
    description = "A modular audio processing system using JACK and LV2 or LADSPA plugins";
    homepage = "http://drobilla.net/software/ingen";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
