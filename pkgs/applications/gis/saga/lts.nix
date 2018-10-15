{ stdenv, fetchgit, gdal, wxGTK30, proj, libiodbc, lzma, jasper,
  libharu, opencv, vigra, postgresql, autoreconfHook, Cocoa
  , unixODBC , poppler, hdf4, hdf5, netcdf, sqlite, qhull, giflib }:

stdenv.mkDerivation rec {
  name = "saga-2.3.2";

  # See https://groups.google.com/forum/#!topic/nix-devel/h_vSzEJAPXs
  # for why the have additional buildInputs on darwin
  buildInputs = [ autoreconfHook gdal wxGTK30 proj libharu opencv vigra
                  postgresql libiodbc lzma jasper
                  unixODBC poppler hdf4.out hdf5 netcdf sqlite qhull giflib ]
                ++ stdenv.lib.optional stdenv.isDarwin Cocoa ;

  enableParallelBuilding = true;

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11 -Wno-narrowing";

  sourceRoot = "code-b6f474f/saga-gis";

  patches = [ ./clang_patch.patch ./finite.patch];

  src = fetchgit {
    url = "https://git.code.sf.net/p/saga-gis/code.git";
    rev = "b6f474f8af4af7f0ff82548cc6f88c53547d91f5";
    sha256 = "0iakynai8mhcwj6wxvafkqhd7b417ss7hyhbcp9wf6092l6vc2zd";
  };

  meta = with stdenv.lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = http://www.saga-gis.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mpickering ];
    platforms = with platforms; unix;
  };
}
