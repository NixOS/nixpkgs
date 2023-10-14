{ lib
, stdenv
, callPackage
, fetchFromGitHub
, makeWrapper
, wrapGAppsHook

, bison
, blas
, cairo
, ffmpeg
, fftw
, flex
, gdal
, geos
, libiconv
, libmysqlclient
, libpng
, libtiff
, libxml2
, netcdf
, pdal
, pkg-config
, postgresql
, proj
, proj-datumgrid
, python3Packages
, readline
, sqlite
, wxGTK32
, zlib
, zstd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grass";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = finalAttrs.version;
    hash = "sha256-YHQtvp/AYMWme46yIc4lE/izjqVePnPxn3GY5RRfPq4=";
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook

    bison
    flex
    gdal # for `gdal-config`
    geos # for `geos-config`
    libmysqlclient # for `mysql_config`
    netcdf # for `nc-config`
    pkg-config
  ] ++ (with python3Packages; [ python-dateutil numpy wxPython_4_2 ]);

  buildInputs = [
    blas
    cairo
    ffmpeg
    fftw
    gdal
    geos
    libmysqlclient
    libpng
    libtiff
    libxml2
    netcdf
    pdal
    postgresql
    proj
    proj-datumgrid
    readline
    sqlite
    wxGTK32
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  strictDeps = true;

  # On Darwin the installer tries to symlink the help files into a system
  # directory
  patches = [ ./no_symbolic_links.patch ];

  # Correct mysql_config query
  patchPhase = ''
      substituteInPlace configure --replace "--libmysqld-libs" "--libs"
  '';

  configureFlags = [
    "--with-blas"
    "--with-fftw"
    "--with-geos"
    # It complains about missing libmysqld but doesn't really seem to need it
    "--with-mysql"
    "--with-mysql-includes=${lib.getDev libmysqlclient}/include/mysql"
    "--with-mysql-libs=${libmysqlclient}/lib/mysql"
    "--with-netcdf"
    "--with-postgres"
    "--with-postgres-libs=${postgresql.lib}/lib/"
    "--with-proj-includes=${proj.dev}/include"
    "--with-proj-libs=${proj}/lib"
    "--with-proj-share=${proj}/share/proj"
    "--with-pthread"
    "--with-readline"
    "--with-wxwidgets"
    "--with-zstd"
    "--without-opengl"
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

  passthru.tests = {
    grass = callPackage ./tests.nix { grass = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    homepage = "https://grass.osgeo.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ mpickering ];
    platforms = platforms.all;
  };
})
