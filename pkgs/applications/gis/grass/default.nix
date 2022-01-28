{ lib, stdenv, fetchFromGitHub, flex, bison, pkg-config, zlib, libtiff, libpng, fftw
, cairo, readline, ffmpeg, makeWrapper, wxGTK30, wxmac, netcdf, blas
, proj, gdal, geos, sqlite, postgresql, libmysqlclient, python3Packages, libLAS, proj-datumgrid
, zstd, pdal, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "grass";
  version = "7.8.6";

  src = with lib; fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = version;
    sha256 = "sha256-zvZqFWuxNyA+hu+NMiRbQVdzzrQPsZrdGdfVB17+SbM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ flex bison zlib proj gdal libtiff libpng fftw sqlite
  readline ffmpeg makeWrapper netcdf geos postgresql libmysqlclient blas
  libLAS proj-datumgrid zstd wrapGAppsHook ]
    ++ lib.optionals stdenv.isLinux [ cairo pdal wxGTK30 ]
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
    chmod +x scripts/d.out.file/d.out.file.py \
      scripts/d.to.rast/d.to.rast.py \
      scripts/d.what.rast/d.what.rast.py \
      scripts/d.what.vect/d.what.vect.py \
      scripts/g.extension/g.extension.py \
      scripts/g.extension.all/g.extension.all.py \
      scripts/r.drain/r.drain.py \
      scripts/r.pack/r.pack.py \
      scripts/r.import/r.import.py \
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
      temporal/t.downgrade/t.downgrade.py \
      temporal/t.select/t.select.py
    for d in gui lib scripts temporal tools; do
      patchShebangs $d
    done
  '';

  postInstall = ''
    wrapProgram $out/bin/grass78 \
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
    maintainers = with lib.maintainers; [mpickering];
  };
}
