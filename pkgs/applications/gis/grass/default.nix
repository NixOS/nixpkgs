{ stdenv, fetchurl, flex, bison, pkgconfig, zlib, libtiff, libpng, fftw
, cairo, readline, ffmpeg, makeWrapper, wxGTK30, netcdf, blas
, proj, gdal, geos, sqlite, postgresql, mysql, pythonPackages
}:

stdenv.mkDerivation {
  name = "grass-7.0.2";
  src = fetchurl {
    url = http://grass.osgeo.org/grass70/source/grass-7.0.2.tar.gz;
    sha256 = "02qrdgn46gxr60amxwax4b8fkkmhmjxi6qh4yfvpbii6ai6diarf";
  };

  buildInputs = [ flex bison zlib proj gdal libtiff libpng fftw sqlite pkgconfig cairo
  readline ffmpeg makeWrapper wxGTK30 netcdf geos postgresql mysql.lib blas ]
    ++ (with pythonPackages; [ python dateutil wxPython30 numpy sqlite3 ]);

  configureFlags = [
    "--with-proj-share=${proj}/share/proj"
    "--without-opengl"
    "--with-readline"
    "--with-wxwidgets"
    "--with-netcdf"
    "--with-geos"
    "--with-postgres" "--with-postgres-libs=${postgresql.lib}/lib/"
    "--with-mysql" "--with-mysql-includes=${mysql.lib}/include/mysql"
    "--with-blas"
  ];

  /* Ensures that the python script run at build time are actually executable;
   * otherwise, patchShebangs ignores them.  */
  postConfigure = ''
    chmod +x scripts/d.out.file/d.out.file.py \
      scripts/d.to.rast/d.to.rast.py \
      scripts/d.what.rast/d.what.rast.py \
      scripts/d.what.vect/d.what.vect.py \
      scripts/g.extension/g.extension.py \
      scripts/g.extension.all/g.extension.all.py \
      scripts/r.pack/r.pack.py \
      scripts/r.tileset/r.tileset.py \
      scripts/r.unpack/r.unpack.py \
      scripts/v.krige/v.krige.py \
      scripts/v.rast.stats/v.rast.stats.py \
      scripts/v.to.lines/v.to.lines.py \
      scripts/v.what.strds/v.what.strds.py \
      scripts/v.unpack/v.unpack.py \
      scripts/wxpyimgview/*.py \
      gui/wxpython/animation/g.gui.animation.py \
      gui/wxpython/rlisetup/g.gui.rlisetup.py \
      gui/wxpython/vdigit/g.gui.vdigit.py \
      temporal/t.rast.accumulate/t.rast.accumulate.py \
      temporal/t.rast.accdetect/t.rast.accdetect.py \
      temporal/t.select/t.select.py
    for d in gui lib scripts temporal tools; do
      patchShebangs $d
    done
  '';

  postInstall = ''
    wrapProgram $out/bin/grass70 \
    --set PYTHONPATH $PYTHONPATH \
    --set GRASS_PYTHON ${pythonPackages.python}/bin/${pythonPackages.python.executable}
    ln -s $out/grass-*/lib $out/lib
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://grass.osgeo.org/;
    description = "GIS software suite used for geospatial data management and analysis, image processing, graphics and maps production, spatial modeling, and visualization";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
