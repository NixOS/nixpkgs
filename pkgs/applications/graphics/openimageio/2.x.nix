{ stdenv
, fetchFromGitHub
, fetchpatch
, boost
, cmake
, ilmbase
, libjpeg
, libpng
, libtiff
, opencolorio
, openexr
, robin-map
, unzip
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "2.1.9.0";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "1bbxx3bcc5jlb90ffxbk29gb8227097rdr8vg97vj9axw2mjd5si";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/OpenImageIO/oiio/pull/2441/commits/e9bdd69596103edf41b659ad8ab0ca4ce002f6f5.patch";
      sha256 = "0x1wmjf1jrm19d1izhs1cs3y1if9al1zx48lahkfswyjag3r5dn0";
    })
  ];

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    ilmbase
    libjpeg
    libpng
    libtiff
    opencolorio
    openexr
    robin-map
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
