{ stdenv, fetchurl, cmake, python2, python3, python2Packages, python3Packages, swig, ncurses, doxygen }:

stdenv.mkDerivation rec {
  version = "0.6.1";
  name = "SoapySDR-${version}";

  src = fetchurl {
    url = "https://github.com/pothosware/SoapySDR/archive/soapy-sdr-${version}.tar.gz";
    sha256 = "1xz9s46zd4684vgsma73kpix79i5rvvas8r92yyj9ywda51qxkrf";
  };

  buildInputs = [ cmake python2 python3 python2Packages.numpy python3Packages.numpy swig ncurses doxygen];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release"
                 "-DUSE_PYTHON_CONFIG=ON"
                 "-DPYTHON_EXECUTABLE=${python2}/bin/python"
                 "-DPYTHON3_EXECUTABLE=${python3}/bin/python"
               ];

  configurePhase = ''
    mkdir -p build
    pushd build

    cmake .. -DCMAKE_INSTALL_PREFIX=$out $cmakeFlags
  '';

  meta = with stdenv.lib; {
    description = "Vendor and platform neutral SDR support library.";
    homepage = https://github.com/pothosware/SoapySDR/wiki;
    license = licenses.boost;
    maintainers = with maintainers; [ roosemberth ];
    platforms = platforms.linux;
  };
}
