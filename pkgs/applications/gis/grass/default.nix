{ lib, stdenv, fetchFromGitHub, flex, bison, pkg-config, zlib, libtiff, libpng, fftw
, cairo, readline, ffmpeg, makeWrapper, wxGTK31, wxmac, netcdf, blas
, proj, gdal, geos, sqlite, postgresql, libmysqlclient, python3Packages, libLAS, proj-datumgrid
, zstd, pdal, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "grass";
  version = "8.2.0";

  src = with lib; fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = version;
    sha256 = "sha256-VK9FCqIwHGmeJe5lk12lpAGcsC1aPRBiI+XjACXjDd4=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ flex bison zlib proj gdal libtiff libpng fftw sqlite
  readline ffmpeg netcdf geos postgresql libmysqlclient blas
  libLAS proj-datumgrid zstd wrapGAppsHook ]
    ++ lib.optionals stdenv.isLinux [ cairo pdal wxGTK31 ]
    ++ lib.optional stdenv.isDarwin wxmac
    ++ (with python3Packages; [ python python-dateutil numpy ]
      ++ lib.optional stdenv.isDarwin wxPython_4_0
      ++ lib.optional stdenv.isLinux wxPython_4_1);

  # On Darwin the installer tries to symlink the help files into a system
  # directory
  patches = [ ./no_symbolic_links.patch ];

  # Correct mysql_config query
  patchPhase = ''
      substituteInPlace configure --replace "--libmysqld-libs" "--libs"
  '';

  configureFlags = [
    "--with-proj-share=${proj}/share/proj"
    "--with-proj-includes=${proj.dev}/include"
    "--with-proj-libs=${proj}/lib"
    "--without-opengl"
    "--with-readline"
    "--with-wxwidgets"
    "--with-netcdf"
    "--with-geos"
    "--with-postgres"
    "--with-postgres-libs=${postgresql.lib}/lib/"
    # it complains about missing libmysqld but doesn't really seem to need it
    "--with-mysql"
    "--with-mysql-includes=${lib.getDev libmysqlclient}/include/mysql"
    "--with-mysql-libs=${libmysqlclient}/lib/mysql"
    "--with-blas"
    "--with-liblas=${libLAS}/bin/liblas-config"
    "--with-zstd"
    "--with-fftw"
    "--with-pthread"
  ] ++ lib.optionals stdenv.isLinux [
    "--with-pdal"
  ] ++ lib.optionals stdenv.isDarwin [
    "--without-cairo"
    "--without-freetype"
    "--without-x"
  ];

  # Otherwise a very confusing "Can't load GDAL library" error
  makeFlags = lib.optional stdenv.isDarwin "GDAL_DYNAMIC=";

  /* Ensures that the python script run at build time are actually executable;
   * otherwise, patchShebangs ignores them.  */
  postConfigure = ''
    for f in $(find . -name '*.py'); do
      chmod +x $f
    done

    patchShebangs */
  '';

  postInstall = ''
    wrapProgram $out/bin/grass \
    --set PYTHONPATH $PYTHONPATH \
    --set GRASS_PYTHON ${python3Packages.python.interpreter} \
    --suffix LD_LIBRARY_PATH ':' '${gdal}/lib'
    ln -s $out/grass*/lib $out/lib
    ln -s $out/grass*/include $out/include
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://grass.osgeo.org/";
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mpickering willcohen ];
  };
}
