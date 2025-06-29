{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  cmake,
}:

stdenv.mkDerivation rec {
  version = "3.23.0";
  pname = "libre";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "re";
    rev = "v${version}";
    sha256 = "sha256-uz+0UU9N3mWK3KjGCBv6n3LKfAmTxp8zhx2dOjnFrnE=";
  };

  buildInputs = [
    openssl
    zlib
  ];

  nativeBuildInputs = [ cmake ];
  makeFlags =
    [
      "USE_ZLIB=1"
      "USE_OPENSSL=1"
      "PREFIX=$(out)"
    ]
    ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
    ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}";
  enableParallelBuilding = true;
  meta = {
    description = "Library for real-time communications with async IO support and a complete SIP stack";
    homepage = "https://github.com/baresip/re";
    maintainers = with lib.maintainers; [ raskin ];
    license = lib.licenses.bsd3;
  };
}
