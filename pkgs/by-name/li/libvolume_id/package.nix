{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvolume_id";
  version = "0.81.1";

  src = fetchurl {
    url = "https://www.marcuscom.com/downloads/libvolume_id-${finalAttrs.version}.tar.bz2";
    sha256 = "029z04vdxxsl8gycm9whcljhv6dy4b12ybsxdb99jr251gl1ifs5";
  };

  preBuild = "
    makeFlagsArray=(prefix=$out E=echo RANLIB=${stdenv.cc.targetPrefix}ranlib INSTALL='install -c')
  ";

  # Work around a broken Makefile.
  postInstall = "
    rm $out/lib/libvolume_id.so.0
    cp -f libvolume_id.so.0 $out/lib/
  ";

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    homepage = "http://www.marcuscom.com/downloads/";
  };
})
