{ lib, stdenv, fetchFromGitHub, flex, bison, pkg-config, zlib, libtiff, libpng, fftw
, cairo, readline, ffmpeg, makeWrapper, wxGTK32, libiconv, netcdf, blas
, proj, gdal, geos, sqlite, postgresql, libmysqlclient, python3Packages, proj-datumgrid
, zstd, pdal, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "grass";
  version = "8.2.1";

  src = with lib; fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = version;
    hash = "sha256-U3PQd3u9i+9Bc7BSd0gK8Ss+iV9BT1xLBDrKydtl3Qk=";
  };

  nativeBuildInputs = [
    pkg-config bison flex makeWrapper wrapGAppsHook
    gdal # for `gdal-config`
    geos # for `geos-config`
    netcdf # for `nc-config`
    libmysqlclient # for `mysql_config`
    pdal # for `pdal-config`; remove with next version, see https://github.com/OSGeo/grass/pull/2851
  ] ++ (with python3Packages; [ python-dateutil numpy wxPython_4_2 ]);

  buildInputs = [
    cairo zlib proj libtiff libpng fftw sqlite
    readline ffmpeg postgresql blas wxGTK32
    proj-datumgrid zstd
    gdal
    geos
    netcdf
    libmysqlclient
    pdal
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

  meta = with lib; {
    homepage = "https://grass.osgeo.org/";
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ mpickering ];
    platforms = platforms.all;
  };
}
