{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  netcdf,
  hdf5,
  curl,
  cmake,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "netcdf-cxx4";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "netcdf-cxx4";
    rev = "v${version}";
    sha256 = "sha256-GZ6n7dW3l8Kqrk2Xp2mxRTUWWQj0XEd2LDTG9EtrfhY=";
  };

  patches = [
    # This fix is included upstream, remove with next upgrade
    ./cmake-h5free.patch
    ./netcdf.patch
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/Unidata/netcdf-cxx4/commit/8455a69867a420cffa226978174bc0f99029bc8b.patch?full_index=1";
      hash = "sha256-AS2nQIXEW1iSR2LAzvTB04M+kyureJAn63+mPNoCq+0=";
    })
  ];

  preConfigure = ''
    appendToVar cmakeFlags "-Dabs_top_srcdir=$(readlink -f ./)"
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    netcdf
    hdf5
    curl
  ];

  doCheck = true;
  enableParallelChecking = false;
  preCheck = ''
    export HDF5_PLUGIN_PATH=${netcdf}/lib/hdf5-plugins
  '';

  meta = {
    description = "C++ API to manipulate netcdf files";
    mainProgram = "ncxx4-config";
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
