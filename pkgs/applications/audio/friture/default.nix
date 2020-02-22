{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "0.37";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ivy5qfd90w1s1icsphvvdnnqz563v3fhg5pws2zn4483cgnzc2y";
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
    homepage = "http://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = [ maintainers.laikq ];
  };
}
