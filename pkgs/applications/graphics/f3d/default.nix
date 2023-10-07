{ lib, stdenv, fetchFromGitHub, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    rev = "refs/tags/v${version}";
    hash = "sha256-2LDHIeKgLUS2ujJUx2ZerXmZYB9rrT3PYvrtzV4vcHM=";
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
    changelog = "https://github.com/f3d-app/f3d/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
  };
}
