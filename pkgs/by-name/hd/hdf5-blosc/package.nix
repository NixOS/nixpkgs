{ lib, stdenv, c-blosc, cmake, hdf5, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hdf5-blosc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = pname;
    rev =  "v${version}";
    sha256 = "1nj2bm1v6ymm3fmyvhbn6ih5fgdiapavlfghh1pvbmhw71cysyqs";
  };

  patches = [ ./no-external-blosc.patch ];

  outputs = [ "out" "dev" "plugin" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ c-blosc hdf5 ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace 'set(BLOSC_INSTALL_DIR "''${CMAKE_CURRENT_BINARY_DIR}/blosc")' 'set(BLOSC_INSTALL_DIR "${c-blosc}")'
  '';

  cmakeFlags = [
    "-DPLUGIN_INSTALL_PATH=${placeholder "plugin"}/hdf5/lib/plugin"
  ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./blosc_filter.pc.in} $out/lib/pkgconfig/blosc_filter.pc
  '';

  meta = with lib; {
    description = "Filter for HDF5 that uses the Blosc compressor";
    homepage = "https://github.com/Blosc/hdf5-blosc";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
