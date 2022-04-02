{ lib, stdenv
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
, pkg-config
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
, spacenavSupport ? stdenv.isLinux, libspnav
}:

mkDerivation rec {
  pname = "openscad";
  version = "2021.01";

  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "${pname}-${version}";
    sha256 = "sha256-2tOLqpFt5klFPxHNONnHVzBKEFWn4+ufx/MU+eYbliA=";
  };

  nativeBuildInputs = [ bison flex pkg-config gettext qmake ];

  buildInputs = [
    eigen boost glew opencsg cgal mpfr gmp glib
    harfbuzz lib3mf libzip double-conversion freetype fontconfig
    qtbase qtmultimedia qscintilla
  ] ++ lib.optionals stdenv.isLinux [ libGLU libGL ]
    ++ lib.optional stdenv.isDarwin qtmacextras
    ++ lib.optional spacenavSupport libspnav
  ;

  qmakeFlags = [ "VERSION=${version}" ] ++
    lib.optionals spacenavSupport [
      "ENABLE_SPNAV=1"
      "SPNAV_INCLUDEPATH=${libspnav}/include"
      "SPNAV_LIBPATH=${libspnav}/lib"
    ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin || true

    mv --target-directory=$out/Applications/OpenSCAD.app/Contents/Resources \
      $out/share/openscad/{examples,color-schemes,locale,libraries,fonts,templates}

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
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bjornfor raskin gebner ];
  };
}
