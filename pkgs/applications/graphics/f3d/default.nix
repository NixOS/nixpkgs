{ lib, stdenv, fetchFromGitLab, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "f3d";
    repo = "f3d";
    rev = "v${version}";
    sha256 = "0lj20k5qyw9z85k3wsp05f7dcv7v7asrnppi8i1jm32dzxjm4siw";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ vtk_9 ]
    ++ lib.optionals stdenv.isLinux [ libGL libX11 ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  meta = with lib; {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://kitware.github.io/F3D";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
  };
}
