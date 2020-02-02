{ stdenv, fetchFromGitHub, flex, bison, pkgconfig, zlib, libtiff, libpng, fftw
, cairo, readline, ffmpeg, makeWrapper, wxGTK30, netcdf, blas
, proj, gdal, geos, sqlite, postgresql, mysql, python2Packages, libLAS, proj-datumgrid
}:

stdenv.mkDerivation rec {
  name = "grass";
  version = "7.6.1";

  src = with stdenv.lib; fetchFromGitHub {
    owner = "OSGeo";
    repo = "grass";
    rev = "${name}_${replaceStrings ["."] ["_"] version}";
    sha256 = "1amjk9rz7vw5ha7nyl5j2bfwj5if9w62nlwx5qbp1x7spldimlll";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ flex bison zlib proj gdal libtiff libpng fftw sqlite cairo proj
  readline ffmpeg makeWrapper wxGTK30 netcdf geos postgresql mysql.connector-c blas
  libLAS proj-datumgrid ]
    ++ (with python2Packages; [ python dateutil wxPython30 numpy ]);

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
    "--with-proj-lib=${proj}/lib"
    "--without-opengl"
    "--with-readline"
    "--with-wxwidgets"
    "--with-netcdf"
    "--with-geos"
    "--with-postgres"
    "--with-postgres-libs=${postgresql.lib}/lib/"
    # it complains about missing libmysqld but doesn't really seem to need it
    "--with-mysql"
    "--with-mysql-includes=${stdenv.lib.getDev mysql.connector-c}/include/mysql"
    "--with-mysql-libs=${mysql.connector-c}/lib/mysql"
    "--with-blas"
    "--with-liblas=${libLAS}/bin/liblas-config"
  ];

  # Otherwise a very confusing "Can't load GDAL library" error
  makeFlags = stdenv.lib.optional stdenv.isDarwin "GDAL_DYNAMIC=";

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

  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1" ];

  postInstall = ''
    wrapProgram $out/bin/grass76 \
    --set PYTHONPATH $PYTHONPATH \
    --set GRASS_PYTHON ${python2Packages.python}/bin/${python2Packages.python.executable} \
    --suffix LD_LIBRARY_PATH ':' '${gdal}/lib'
    ln -s $out/grass*/lib $out/lib
    ln -s $out/grass*/include $out/include
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://grass.osgeo.org/;
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [mpickering];
  };
}
