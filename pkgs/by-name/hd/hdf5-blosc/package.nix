{
  lib,
  stdenv,
  c-blosc,
  cmake,
  hdf5,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "hdf5-blosc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "hdf5-blosc";
    rev = "v${version}";
    sha256 = "sha256-pM438hUEdzdZEGYxoKlBAHi1G27auj9uGSeiXwVPAE8=";
  };

  patches = [ ./no-external-blosc.patch ];

  outputs = [
    "out"
    "dev"
    "plugin"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    c-blosc
    hdf5
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace-fail 'set(BLOSC_INSTALL_DIR "''${CMAKE_CURRENT_BINARY_DIR}/blosc")' 'set(BLOSC_INSTALL_DIR "${c-blosc}")'
  '';

  cmakeFlags = [
    "-DPLUGIN_INSTALL_PATH=${placeholder "plugin"}/hdf5/lib/plugin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_TESTS=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.10)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./blosc_filter.pc.in} $out/lib/pkgconfig/blosc_filter.pc
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Filter for HDF5 that uses the Blosc compressor";
    homepage = "https://github.com/Blosc/hdf5-blosc";
    license = licenses.mit;
  };
}
