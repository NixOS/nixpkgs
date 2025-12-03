{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  libxmlxx,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ciftilib";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Washington-University";
    repo = "CiftiLib";
    tag = "v${version}";
    hash = "sha256-xc2dpMse4SozYEV/w3rXCrh1LKpTThq5nHB2y5uAD0A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    boost
    libxmlxx
    zlib
  ];

  cmakeFlags = [ "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'big|datatype-md5'" ];

  # error: no member named 'file_string' in 'boost::filesystem::path';
  # error: 'class boost::filesystem::path' has no member named 'normalize', resp.
  env.NIX_CFLAGS_COMPILE = "-UCIFTILIB_BOOST_NO_FSV3 -UCIFTILIB_BOOST_NO_CANONICAL";

  doCheck = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "CMAKE_POLICY(VERSION 2.8.7)" "CMAKE_POLICY(VERSION 3.10)" \
      --replace-fail "CMAKE_POLICY(SET CMP0045 OLD)" ""
  '';

  meta = with lib; {
    homepage = "https://github.com/Washington-University/CiftiLib";
    description = "Library for reading and writing CIFTI files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    license = licenses.bsd2;
  };
}
