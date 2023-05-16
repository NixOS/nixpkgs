<<<<<<< HEAD
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

stdenv.mkDerivation (finalAttrs: rec {
  pname = "grass";
  version = "8.3.0";
=======
{ lib, stdenv, fetchFromGitHub, flex, bison, pkg-config, zlib, libtiff, libpng, fftw
, cairo, readline, ffmpeg, makeWrapper, wxGTK32, libiconv, netcdf, blas
, proj, gdal, geos, sqlite, postgresql, libmysqlclient, python3Packages, proj-datumgrid
, zstd, pdal, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "grass";
  version = "8.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = with lib; fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = version;
<<<<<<< HEAD
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
=======
    sha256 = "sha256-VK9FCqIwHGmeJe5lk12lpAGcsC1aPRBiI+XjACXjDd4=";
  };

  nativeBuildInputs = [
    pkg-config bison flex makeWrapper wrapGAppsHook
    gdal geos libmysqlclient netcdf pdal
  ] ++ (with python3Packages; [ python-dateutil numpy wxPython_4_2 ]);

  buildInputs = [
    cairo zlib proj libtiff libpng fftw sqlite
    readline ffmpeg postgresql blas wxGTK32
    proj-datumgrid zstd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
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
=======
  meta = {
    homepage = "https://grass.osgeo.org/";
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mpickering willcohen ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
