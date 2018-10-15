{ stdenv, fetchurl, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql, Cocoa,
  unixODBC , poppler, hdf4, hdf5, netcdf, sqlite, qhull, giflib }:

stdenv.mkDerivation rec {
  name = "saga-6.3.0";

  # See https://groups.google.com/forum/#!topic/nix-devel/h_vSzEJAPXs
  # for why the have additional buildInputs on darwin
  buildInputs = [ gdal wxGTK30 proj libharu opencv vigra postgresql libiodbc lzma
                  jasper qhull giflib ]
                ++ stdenv.lib.optionals stdenv.isDarwin
                  [ Cocoa unixODBC poppler hdf4.out hdf5 netcdf sqlite ];

  enableParallelBuilding = true;

  patches = [ ./finite-6.3.0.patch];

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11 -Wno-narrowing";

  src = fetchurl {
    url = "mirror://sourceforge/project/saga-gis/SAGA%20-%206/SAGA%20-%206.3.0/saga-6.3.0.tar.gz";
    sha256 = "0hyjim8fcp3mna1hig22nnn4ki3j6b7096am2amcs99sdr09jjxv";
  };

  meta = with stdenv.lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michelk mpickering ];
    platforms = with platforms; unix;
  };
}
