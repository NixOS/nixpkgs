{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  libre,
  cmake,
}:

stdenv.mkDerivation rec {
  version = "2.12.0";
  pname = "librem";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "rem";
    rev = "v${version}";
    sha256 = "sha256-MsXSUxFH89EqxMe4285xFV1Tsqmv2l5RnEeli48O3XQ=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    openssl
    libre
  ];
  cmakeFlags = [
    "-DRE_INCLUDE_DIR=${libre}/include/re"
  ];
  makeFlags =
    [
      "LIBRE_MK=${libre}/share/re/re.mk"
      "PREFIX=$(out)"
      "AR=${stdenv.cc.targetPrefix}ar"
    ]
    ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${lib.getDev stdenv.cc.cc}"
    ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}";
  enableParallelBuilding = true;
  meta = {
    description = "Library for real-time audio and video processing";
    homepage = "https://github.com/baresip/rem";
    maintainers = with lib.maintainers; [ raskin ];
    license = lib.licenses.bsd3;
  };
}
