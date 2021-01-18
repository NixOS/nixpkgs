{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "unstable-2020-02-16";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "4460b4e72a9c55310d6438f294424b5be74fc0aa";
    sha256 = "1pmxzq78ibifby3gbir1ah30mgsqv0y7zladf5qf3sl5r1as0yym";
  };

  nativeBuildInputs = (with py; [ numpy cython scipy ]) ++
    [ wrapQtAppsHook ];

  propagatedBuildInputs = with py; [
    sounddevice
    pyopengl
    pyopengl-accelerate
    docutils
    numpy
    pyqt5
    appdirs
    pyrr
    rtmixer
  ];

  patches = [
    ./unlock_constraints.patch
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "A real-time audio analyzer";
    homepage = "http://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = [ maintainers.laikq ];
  };
}
