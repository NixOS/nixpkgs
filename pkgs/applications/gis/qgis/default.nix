{ stdenv, fetchurl, fetchpatch, gdal, cmake, qt4, flex, bison, proj, geos, xlibsWrapper, sqlite, gsl
, qwt, fcgi, python2Packages, libspatialindex, libspatialite, qscintilla, postgresql, makeWrapper
, qjson, qca2, txt2tags, openssl
, withGrass ? false, grass
}:

stdenv.mkDerivation rec {
  name = "qgis-2.18.15";

  buildInputs = [ gdal qt4 flex openssl bison proj geos xlibsWrapper sqlite gsl qwt qscintilla
    fcgi libspatialindex libspatialite postgresql qjson qca2 txt2tags ] ++
    (stdenv.lib.optional withGrass grass) ++
    (with python2Packages; [ jinja2 numpy psycopg2 pygments requests python2Packages.qscintilla sip ]);

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
    sha256 = "1jpprkk91s2wwx0iiqlnsngxnn52zs32bad799fjai58nrsh8b7b";
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
