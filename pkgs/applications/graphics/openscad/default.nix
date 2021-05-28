{ stdenv
, fetchFromGitHub
, qtbase
, qtmultimedia
, qscintilla
, bison
, flex
, eigen
, boost
, libGLU, libGL
, glew
, opencsg
, cgal
, mpfr
, gmp
, glib
, pkgconfig
, harfbuzz
, gettext
, freetype
, fontconfig
, double-conversion
, lib3mf
, libzip
, mkDerivation
, qtmacextras
, qmake
}:

mkDerivation rec {
  pname = "openscad";
  version = "2019.05";

  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "${pname}-${version}";
    sha256 = "1qz384jqgk75zxk7sqd22ma9pyd94kh4h6a207ldx7p9rny6vc5l";
  };

  nativeBuildInputs = [ bison flex pkgconfig gettext qmake ];

  buildInputs = [
    eigen boost glew opencsg cgal mpfr gmp glib
    harfbuzz lib3mf libzip double-conversion freetype fontconfig
    qtbase qtmultimedia qscintilla
  ] ++ stdenv.lib.optionals stdenv.isLinux [ libGLU libGL ]
    ++ stdenv.lib.optional stdenv.isDarwin qtmacextras
  ;

  qmakeFlags = [ "VERSION=${version}" ];

  # src/lexer.l:36:10: fatal error: parser.hxx: No such file or directory
  enableParallelBuilding = false; # true by default due to qmake

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin || true

    wrapQtApp "$out"/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

    mv --target-directory=$out/Applications/OpenSCAD.app/Contents/Resources \
      $out/share/openscad/{examples,color-schemes,locale,libraries,fonts}

    rmdir $out/share/openscad
  '';

  meta = {
    description = "3D parametric model compiler";
    longDescription = ''
      OpenSCAD is a software for creating solid 3D CAD objects. It is free
      software and available for Linux/UNIX, MS Windows and macOS.

      Unlike most free software for creating 3D models (such as the famous
      application Blender) it does not focus on the artistic aspects of 3D
      modelling but instead on the CAD aspects. Thus it might be the
      application you are looking for when you are planning to create 3D models of
      machine parts but pretty sure is not what you are looking for when you are more
      interested in creating computer-animated movies.
    '';
    homepage = "http://openscad.org/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ bjornfor raskin gebner ];
  };
}
