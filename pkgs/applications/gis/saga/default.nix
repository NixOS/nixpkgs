{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma,
  libharu, opencv, vigra, postgresql, Cocoa,
  unixODBC , poppler, hdf4, hdf5, netcdf, sqlite, qhull, giflib }:

stdenv.mkDerivation {
  pname = "saga";
  version = "7.6.1";

  # See https://groups.google.com/forum/#!topic/nix-devel/h_vSzEJAPXs
  # for why the have additional buildInputs on darwin
  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma
                  qhull giflib ]
                ++ stdenv.lib.optionals stdenv.isDarwin
                  [ Cocoa unixODBC poppler hdf4.out hdf5 netcdf sqlite ];

  enableParallelBuilding = true;

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11 -Wno-narrowing";

  src = fetchurl {
    url = "https://sourceforge.net/projects/saga-gis/files/SAGA%20-%207/SAGA%20-%207.6.1/saga-7.6.1.tar.gz";
    sha256 = "1i0cp1lms6cmjl7f5vgr9pl3qc02fmappn4kq21y0dn2gy7j2mkn";
  };

  meta = with stdenv.lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = "http://www.saga-gis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michelk mpickering ];
    platforms = with platforms; unix;
  };
}
