{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  gperftools,
  gflags,
  openssl,
  zlib,
  protobuf,
  leveldb,
}:

stdenv.mkDerivation rec{
  pname = "brpc";
  version = "1.12.1";

  src = fetchFromGitHub ({
    owner = "apache";
    repo = "brpc";
    rev = version;
    sha256 = "sha256-BKT3oaFR3fAet96w1b+fAsS48M5DcmPdFdYeTWMZPLY=";
  });

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gtest ];
  propagatedBuildInputs = [ openssl zlib leveldb protobuf gflags gperftools ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_GTEST" false)
  ];

  doCheck = true;

  patches = [
  ];

  preFixup = ''
      substituteInPlace "$out/lib/pkgconfig/brpc.pc" \
        --replace 'includedir=''${prefix}//' 'includedir=/' \
        --replace 'libdir=''${prefix}//' 'libdir=/'
  '';


  meta = with lib; {
    description = "an Industrial-grade RPC framework using C++ Language";
    homepacge   = "https://github.com/apache/brpc";
    license     = licenses.asl20;
    platforms   = platforms.all;
  };
}