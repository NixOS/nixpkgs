{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "0.36";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = "friture";
    rev = "v${version}";
    sha256 = "1pz8v0qbzqq3ig9w33cp027s6c8rj316x5sy8pqs5nsiny9ddnk6";
  };

  # module imports scipy.misc.factorial, but it has been removed since scipy
  # 1.3.0; use scipy.special.factorial instead
  patches = [ ./factorial.patch ];

  nativeBuildInputs = (with py; [ numpy cython scipy ]) ++
    [ wrapQtAppsHook ];

  propagatedBuildInputs = with py; [
    sounddevice
    pyopengl
    docutils
    numpy
    pyqt5
    appdirs
    pyrr
  ];

  postFixup = ''
    wrapQtApp $out/bin/friture
    wrapQtApp $out/bin/.friture-wrapped
  '';

  meta = with lib; {
    description = "A real-time audio analyzer";
    homepage = http://friture.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.laikq ];
  };
}
