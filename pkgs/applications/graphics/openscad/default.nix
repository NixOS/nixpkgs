{ stdenv, fetchurl, qt4, bison, flex, eigen, boost, mesa, glew, opencsg, cgal
, mpfr, gmp }:

stdenv.mkDerivation rec {
  version = "2013.06";
  name = "openscad-${version}";

  src = fetchurl {
    url = "https://openscad.googlecode.com/files/${name}.src.tar.gz";
    sha256 = "01r013l8zyfkgmqn05axh3rlfsjwd6j403w5ffl7nby4i2spiw1f";
  };

  buildInputs = [ qt4 bison flex eigen boost mesa glew opencsg cgal gmp mpfr ];

  configurePhase = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${eigen}/include/eigen*) "
    qmake PREFIX="$out" VERSION=${version}
  '';

  doCheck = false;

  meta = {
    description = "3D parametric model compiler";
    longDescription = ''
      OpenSCAD is a software for creating solid 3D CAD objects. It is free
      software and available for Linux/UNIX, MS Windows and Mac OS X.

      Unlike most free software for creating 3D models (such as the famous
      application Blender) it does not focus on the artistic aspects of 3D
      modelling but instead on the CAD aspects. Thus it might be the
      application you are looking for when you are planning to create 3D models of
      machine parts but pretty sure is not what you are looking for when you are more
      interested in creating computer-animated movies.
    '';
    homepage = "http://openscad.org/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; 
      [ bjornfor raskin the-kenny ];
  };
}
