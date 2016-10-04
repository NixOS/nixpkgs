{ stdenv, fetchurl, gdal, cmake, qt4, flex, bison, proj, geos, xlibsWrapper, sqlite, gsl
, qwt, fcgi, pythonPackages, libspatialindex, libspatialite, qscintilla, postgresql, makeWrapper
, qjson, qca2, txt2tags, openssl
, withGrass ? false, grass
}:

stdenv.mkDerivation rec {
  name = "qgis-2.16.2";

  buildInputs = [ gdal qt4 flex openssl bison proj geos xlibsWrapper sqlite gsl qwt qscintilla
    fcgi libspatialindex libspatialite postgresql qjson qca2 txt2tags ] ++
    (stdenv.lib.optional withGrass grass) ++
    (with pythonPackages; [ numpy psycopg2 requests2 pythonPackages.qscintilla sip ]);

  nativeBuildInputs = [ cmake makeWrapper ];

  # fatal error: ui_qgsdelimitedtextsourceselectbase.h: No such file or directory
  #enableParallelBuilding = true;

  # To handle the lack of 'local' RPATH; required, as they call one of
  # their built binaries requiring their libs, in the build process.
  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/output/lib:${stdenv.lib.makeLibraryPath [ openssl ]}:$LD_LIBRARY_PATH
  '';

  src = fetchurl {
    url = "http://qgis.org/downloads/${name}.tar.bz2";
    sha256 = "0dll8klz0qfba4c1y7mp9k4y4azlay0sypvryicggllk1hna4w0n";
  };

  cmakeFlags = stdenv.lib.optional withGrass "-DGRASS_PREFIX7=${grass}/${grass.name}";

  postInstall = ''
    wrapProgram $out/bin/qgis \
      --prefix PYTHONPATH : $PYTHONPATH \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ openssl ]}
  '';

  meta = {
    description = "User friendly Open Source Geographic Information System";
    homepage = http://www.qgis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
