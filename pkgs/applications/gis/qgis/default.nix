{ stdenv, fetchurl, fetchpatch, gdal, cmake, qt4, flex, bison, proj, geos, xlibsWrapper, sqlite, gsl
, qwt, fcgi, python2Packages, libspatialindex, libspatialite, qscintilla, postgresql, makeWrapper
, qjson, qca2, txt2tags, openssl, darwin, pkgconfig
, withGrass ? true, grass, saga, IOKit, ApplicationServices
}:

stdenv.mkDerivation rec {
  name = "qgis-2.18.28";

  buildInputs = [ gdal qt4 flex openssl bison proj geos xlibsWrapper sqlite gsl qwt qscintilla
    fcgi libspatialindex libspatialite postgresql qjson qca2 txt2tags pkgconfig
    saga ]
  ++
    (stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices])
  ++
    (stdenv.lib.optional withGrass grass) ++
    (stdenv.lib.optional (stdenv.isDarwin && withGrass) darwin.apple_sdk.libs.utmp) ++
    (with python2Packages; [ jinja2 numpy psycopg2 pygments requests python2Packages.qscintilla sip ]);

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

  # `make -f src/providers/wms/CMakeFiles/wmsprovider_a.dir/build.make src/providers/wms/CMakeFiles/wmsprovider_a.dir/qgswmssourceselect.cpp.o`:
  # fatal error: ui_qgsdelimitedtextsourceselectbase.h: No such file or directory
  enableParallelBuilding = false;

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libspatialindex)"
  '';

  # To handle the lack of 'local' RPATH; required, as they call one of
  # their built binaries requiring their libs, in the build process.
  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/output/lib:${stdenv.lib.makeLibraryPath [ openssl ]}:$LD_LIBRARY_PATH
  '';

  src = fetchurl {
    url = "https://qgis.org/downloads/${name}.tar.bz2";
    sha256 = "18pijqls1isd2bpg0mkrw07jqvdfaiwwb9mvz7p2xrgqcjx7dxsq";
  };

  patches = [
    # already merged upstream in QGIS-3.*, but needs to be backported to QGIS-2
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/qgis/QGIS/pull/7263.patch";
      name = "Ensure_qgis.db_is_writable_when_copied_from_RO_source";
      sha256 = "19wr2kz0x8x6p2n0ylzd4lqrdmbkxyxr0zpwf2vl9hdp92rdjxbv";
    })
  ];

  # CMAKE_FIND_FRAMEWORK=never stops the installer choosing system
  # installed frameworks
  # QGIS_MACAPP_BUNDLE=0 stops the installer copying the Qt binaries into the
  # installation which causes havoc
  # Building RelWithDebInfo allows QGIS_DEBUG to print debugging information
  cmakeFlags = stdenv.lib.optional withGrass "-DGRASS_PREFIX7=${grass}/${grass.name}"
               ++ stdenv.lib.optional stdenv.isDarwin
                    (["-DCMAKE_FIND_FRAMEWORK=never"]
                      ++ ["-DQGIS_MACAPP_BUNDLE=0"]);
#                     ++ ["-DCMAKE_BUILD_TYPE=RelWithDebInfo"];



  postInstall =
    (stdenv.lib.optionalString stdenv.isLinux ''
          wrapProgram $out/bin/qgis \
            --set PYTHONPATH $PYTHONPATH \
            --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ openssl ]}
          '') +
    (stdenv.lib.optionalString stdenv.isDarwin ''
      # Necessary for QGIS to find the correct default GRASS path
      # Plugins look for gdal tools like deminfo on the PATH
      ${stdenv.lib.optionalString withGrass "ln -sf ${grass} $out/QGIS.app/Contents/MacOS/grass"}
      # Necessary for QGIS to find the right SAGA installation
      ln -sf ${saga}/bin/saga_cmd $out/QGIS.app/Contents/MacOS/bin/saga_cmd
      for file in $(find $out -type f -name "QGIS"); do
        wrapProgram "$file" \
          --prefix DYLD_LIBRARY_PATH : "${qwt}/lib" \
          --prefix DYLD_LIBRARY_PATH : "${qscintilla}/lib" \
          --prefix PATH : "${gdal}/bin" \
          ${stdenv.lib.optionalString withGrass "--prefix PATH : ${grass}/bin"} \
          --set PYTHONPATH $PYTHONPATH
      done
      mkdir -p $out/bin
      ln -s $out/QGIS.app/Contents/MacOS/QGIS $out/bin/qgis
      '');

  meta = {
    description = "User friendly Open Source Geographic Information System";
    homepage = http://www.qgis.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [mpickering];
  };
}
