{ bison
, blas
, cairo
, fetchFromGitHub
, ffmpeg
, fftw
, flex
, gdal
, geos
, lib
, libLAS
, libpng
, libmysqlclient
, libtiff
, makeWrapper
, netcdf
, pkg-config
, postgresql
, proj_7
, proj-datumgrid
, python3Packages
, readline
, sqlite
, stdenv
, wxGTK30
, zstd
}:

let proj = proj_7; in
stdenv.mkDerivation rec {
  name = "grass";
  version = "7.8.6";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = version;
    sha256 = "1cs9zrg0gmfp37frmc8gnk776ms1bcj353gghqz20dxidcanmxnf";
  };

  # FIXME:
  # On Darwin the installer tries to symlink the help files into a system
  # directory
  # patches = [ ./no_symbolic_links.patch ];

  postPatch = ''
    # Correct mysql_config query
    substituteInPlace configure --replace "--libmysqld-libs" "--libs"
  '';

  configureFlags = [
    "--with-proj=${proj}/bin/proj"
    "--with-proj-share=${proj}/share/proj"
    "--with-proj-includes=${proj.dev}/include"
    "--with-proj-lib=${proj}/lib"
    "--without-opengl"
    "--with-readline"
    "--with-wxwidgets"
    "--with-netcdf"
    "--with-bzlib"
    "--with-geos"
    "--with-postgres"
    "--with-postgres-libs=${postgresql.lib}/lib/"
    # it complains about missing libmysqld but doesn't really seem to need it
    "--with-mysql"
    "--with-mysql-includes=${lib.getDev libmysqlclient}/include/mysql"
    "--with-mysql-libs=${libmysqlclient}/lib/mysql"
    "--with-blas"
    "--with-liblas=${libLAS}/bin/liblas-config"
  ];

  # Otherwise a very confusing "Can't load GDAL library" error
  makeFlags = lib.optional stdenv.isDarwin "GDAL_DYNAMIC=";

  # FIXME: postConfigure needs fixing. List of files may have changed.
  /* Ensures that the python script run at build time are actually executable;
   * otherwise, patchShebangs ignores them.  */
  postConfigure = ''
    chmod +x scripts/d.out.file/d.out.file.py \
      scripts/d.to.rast/d.to.rast.py \
      scripts/d.what.rast/d.what.rast.py \
      scripts/d.what.vect/d.what.vect.py \
      scripts/g.extension/g.extension.py \
      scripts/g.extension.all/g.extension.all.py \
      scripts/r.drain/r.drain.py \
      scripts/r.pack/r.pack.py \
      scripts/r.tileset/r.tileset.py \
      scripts/r.unpack/r.unpack.py \
      scripts/v.clip/v.clip.py \
      scripts/v.rast.stats/v.rast.stats.py \
      scripts/v.to.lines/v.to.lines.py \
      scripts/v.what.strds/v.what.strds.py \
      scripts/v.unpack/v.unpack.py \
      scripts/wxpyimgview/*.py \
      gui/wxpython/animation/g.gui.animation.py \
      gui/wxpython/datacatalog/g.gui.datacatalog.py \
      gui/wxpython/rlisetup/g.gui.rlisetup.py \
      gui/wxpython/vdigit/g.gui.vdigit.py \
      temporal/t.rast.accumulate/t.rast.accumulate.py \
      temporal/t.rast.accdetect/t.rast.accdetect.py \
      temporal/t.rast.algebra/t.rast.algebra.py \
      temporal/t.rast3d.algebra/t.rast3d.algebra.py \
      temporal/t.vect.algebra/t.vect.algebra.py \
      temporal/t.select/t.select.py
    for d in gui lib scripts temporal tools; do
      patchShebangs $d
    done
  '';

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bison
    blas
    cairo
    ffmpeg
    fftw
    flex
    gdal
    geos
    libLAS
    libmysqlclient
    libpng
    libtiff
    makeWrapper
    netcdf
    postgresql
    proj
    proj-datumgrid
    readline
    sqlite
    wxGTK30
    zstd
  ] ++ (with python3Packages; [
    python
    dateutil
    wxPython
    numpy
    pyproj
    #vecLib # Missing: https://pypi.org/project/vecLib/
    zstandard
    zstd
  ]);

  postInstall = ''
    wrapProgram $out/bin/grass${lib.versions.majorMinor version} \
    --set PYTHONPATH $PYTHONPATH \
    --set GRASS_PYTHON ${python3Packages.python}/bin/${python3Packages.python.executable} \
    --suffix LD_LIBRARY_PATH ':' '${gdal}/lib'
    ln -s $out/grass*/lib $out/lib
    ln -s $out/grass*/include $out/include
  '';

  meta = {
    broken = true; # 2021-10-19
    homepage = "https://grass.osgeo.org/";
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mpickering ];
  };
}
