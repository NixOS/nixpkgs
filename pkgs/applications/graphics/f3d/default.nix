{ lib, stdenv, fetchFromGitHub, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    rev = "v${version}";
    sha256 = "sha256-ToFP2Q+Oi+MEU9FEe5CNp0pD0bQUBQh34B9guajnqgI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ vtk_9 ]
    ++ lib.optionals stdenv.isLinux [ libGL libX11 ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  meta = with lib; {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://f3d-app.github.io/f3d";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
  };
}
