{ lib, stdenv, fetchFromGitHub, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-2LDHIeKgLUS2ujJUx2ZerXmZYB9rrT3PYvrtzV4vcHM=";
=======
    rev = "v${version}";
    hash = "sha256-od8Wu8+HyQb8qTA6C4kiw5hNI2WPBs/EMt321BJDZoc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/f3d-app/f3d/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
  };
}
