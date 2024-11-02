{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  boost,
  gmp,
  procps,
}:

stdenv.mkDerivation {
  pname = "libsnark";
  version = "20140603-unstable-2024-02-23";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    boost
    gmp
  ] ++ lib.optional stdenv.hostPlatform.isLinux procps;

  cmakeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [ "-DWITH_PROCPS=OFF" ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin || !stdenv.hostPlatform.isx86) [
      "-DWITH_SUPERCOP=OFF"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isx86) [ "-DCURVE=ALT_BN128" ];

  src = fetchFromGitHub {
    owner = "scipr-lab";
    repo = "libsnark";
    rev = "6c705e3135f585c222813654caedc86520fda1f6";
    hash = "sha256-5Gk24fwVaXBWEFmhTsN9Qm8x/Qpr1KjavI3staJidxQ=";
    fetchSubmodules = true;
  };

  meta = {
    description = "C++ library for zkSNARKs";
    homepage = "https://github.com/scipr-lab/libsnark";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
