{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gmp,
  openssl,
  pkg-config,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "libff";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "scipr-lab";
    repo = "libff";
    rev = "v${version}";
    sha256 = "0dczi829497vqlmn6n4fgi89bc2h9f13gx30av5z2h6ikik7crgn";
    fetchSubmodules = true;
  };

  cmakeFlags =
    [ "-DWITH_PROCPS=Off" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      "-DCURVE=ALT_BN128"
      "-DUSE_ASM=OFF"
    ];

  postPatch = lib.optionalString (!enableStatic) ''
    substituteInPlace libff/CMakeLists.txt --replace "STATIC" "SHARED"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    gmp
    openssl
  ];

  meta = with lib; {
    description = "C++ library for Finite Fields and Elliptic Curves";
    changelog = "https://github.com/scipr-lab/libff/blob/develop/CHANGELOG.md";
    homepage = "https://github.com/scipr-lab/libff";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}
