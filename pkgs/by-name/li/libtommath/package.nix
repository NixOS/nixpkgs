{
  lib,
  stdenv,
  fetchurl,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "libtommath";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/libtom/libtommath/releases/download/v${version}/ltm-${version}.tar.xz";
    sha256 = "sha256-KWJy2TQ1mRMI63NgdgDANLVYgHoH6CnnURQuZcz6nQg=";
  };

  postPatch = ''
    substituteInPlace makefile.shared \
      --replace-fail glibtool libtool \
      --replace-fail libtool "${lib.getExe (libtool.override { stdenv = stdenv; })}"
    substituteInPlace makefile_include.mk \
      --replace-fail "gcc" "${stdenv.cc.targetPrefix}cc"
  '';

  preBuild = ''
    makeFlagsArray=(PREFIX=$out \
      CC=${stdenv.cc.targetPrefix}cc \
      INSTALL_GROUP=$(id -g) \
      INSTALL_USER=$(id -u))
  '';

  makefile = "makefile.shared";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.libtom.net/LibTomMath/";
    description = "Library for integer-based number-theoretic applications";
    license = with licenses; [
      publicDomain
      wtfpl
    ];
    platforms = platforms.unix;
  };
}
