{ lib, stdenv, fetchurl, qmake, qtbase, libGLU, AGL }:

stdenv.mkDerivation rec {
  pname = "libqglviewer";
  version = "2.9.1";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/libQGLViewer-${version}.tar.gz";
    sha256 = "sha256-J4+DKgstPvvg1pUhGd+8YFh5C3oPGHaQmDfLZzzkP/M=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase libGLU ]
    ++ lib.optional stdenv.hostPlatform.isDarwin AGL;

  dontWrapQtApps = true;

  postPatch = ''
    cd QGLViewer
  '';

  meta = with lib; {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = "http://libqglviewer.com";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
