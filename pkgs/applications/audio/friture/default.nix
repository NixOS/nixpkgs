{ lib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

let
  py = python3Packages;
in py.buildPythonApplication rec {
  pname = "friture";
  version = "0.47";

  src = fetchFromGitHub {
    owner = "tlecomte";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qcsvmgdz9hhv5gaa918147wvng6manc4iq8ci6yr761ljqrgwjx";
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
    homepage = "https://friture.org/";
    license = licenses.gpl3;
    platforms = platforms.linux; # fails on Darwin
    maintainers = [ maintainers.laikq ];
  };
}
