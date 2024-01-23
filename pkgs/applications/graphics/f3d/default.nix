{ lib
, stdenv
, fetchFromGitHub
, cmake
, help2man
, gzip
, vtk_9
, autoPatchelfHook
, libX11
, libGL
, Cocoa
, OpenGL
}:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "2.2.1";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Pg8uvrUGPKPmsn24q5HPMg9dgvukAXBgSVTW0NiCME=";
  };

  nativeBuildInputs = [
    cmake
    help2man
    gzip
    # https://github.com/f3d-app/f3d/pull/1217
    autoPatchelfHook
  ];

  buildInputs = [ vtk_9 ] ++ lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  cmakeFlags = [
    # conflict between VTK and Nixpkgs;
    # see https://github.com/NixOS/nixpkgs/issues/89167
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"

    "-DF3D_LINUX_GENERATE_MAN=ON"
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
