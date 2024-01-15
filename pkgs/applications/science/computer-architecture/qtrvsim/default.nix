{ lib, stdenv, fetchFromGitHub, cmake, wrapQtAppsHook, qtbase }:

stdenv.mkDerivation rec {
  pname = "QtRVSim";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "cvut";
    repo = "qtrvsim";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cC3DvQj2VBnGad6ZDn3x4gHQfsPpySzjTi17PQoaxPU=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "RISC-V CPU simulator for education purposes";
    longDescription = ''
      RISC-V CPU simulator for education purposes with pipeline and cache visualization.
      Developed at FEE CTU for computer architecture classes.
    '';
    homepage = "https://github.com/cvut/qtrvsim";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jdupak ];
    mainProgram = "qtrvsim_gui";
  };
}
