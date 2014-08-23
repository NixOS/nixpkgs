{ stdenv, fetchurl, qt4, bison, flex, eigen, boost, mesa, glew, opencsg, cgal
, mpfr, gmp, glib, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "2014.03";
  name = "openscad-${version}";

  src = fetchurl {
    url = "http://files.openscad.org/${name}.src.tar.gz";
    sha256 = "1hv1lmq1ayhlvrz5sqipg650xryq25a9k22ysdw0dsrwg9ixqpw6";
  };

  buildInputs = [
    qt4 bison flex eigen boost mesa glew opencsg cgal mpfr gmp glib pkgconfig
  ];

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
