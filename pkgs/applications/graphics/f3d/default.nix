{ lib, stdenv, fetchFromGitHub, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    rev = "v${version}";
    hash = "sha256-od8Wu8+HyQb8qTA6C4kiw5hNI2WPBs/EMt321BJDZoc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ vtk_9 ] ++ lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  # conflict between VTK and Nixpkgs;
  # see https://github.com/NixOS/nixpkgs/issues/89167
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
  ];

  meta = with lib; {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://f3d-app.github.io/f3d";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
  };
}
