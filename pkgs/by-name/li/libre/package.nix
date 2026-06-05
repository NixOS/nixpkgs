{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.8.1";
  pname = "libre";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "re";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fy7K7VE84E8JLWR9UZwHydL+I7NiAtlO8U4Gdr6m2KE=";
  };

  buildInputs = [
    openssl
    zlib
  ];

  nativeBuildInputs = [ cmake ];
  makeFlags = [
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
})
