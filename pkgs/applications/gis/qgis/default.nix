{ stdenv, fetchurl, fetchpatch, gdal, cmake, qt4, flex, bison, proj, geos, xlibsWrapper, sqlite, gsl
, qwt, fcgi, python2Packages, libspatialindex, libspatialite, qscintilla, postgresql, makeWrapper
, qjson, qca2, txt2tags, openssl, darwin, pkgconfig
, withGrass ? true, grass, IOKit, ApplicationServices
}:

stdenv.mkDerivation rec {
  name = "qgis-2.18.22";

  buildInputs = [ gdal qt4 flex openssl bison proj geos xlibsWrapper sqlite gsl qwt qscintilla
    fcgi libspatialindex libspatialite postgresql qjson qca2 txt2tags pkgconfig ]
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
    sha256 = "00b3a2hfn3i7bdx7x96vz2nj0976vpkhid4ss7n8c33fdvw3k82a";
  };

  patches = [
    # https://github.com/qgis/QGIS/pull/7765
    (fetchpatch {
      url = "https://github.com/qgis/QGIS/commit/6b61ef361a77f057dc29eb07463007bd9012b253.patch";
      sha256 = "1xibcahm18n7nxff1xvwwzjf505hvhiw5dk12is7aclv49h0rdf7";
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
