{
  stdenv,
  lib,
  fetchurl,
  cmake,
}:

let
  isCross = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  isStatic = stdenv.hostPlatform.isStatic;
  isMusl = stdenv.hostPlatform.isMusl;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "libptytty";
  version = "2.0";

  src = fetchurl {
    url = "http://dist.schmorp.de/libptytty/libptytty-${finalAttrs.version}.tar.gz";
    sha256 = "1xrikmrsdkxhdy9ggc0ci6kg5b1hn3bz44ag1mk5k1zjmlxfscw0";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    lib.optional isStatic "-DBUILD_SHARED_LIBS=OFF"
    ++ lib.optional (isCross || isStatic) "-DTTY_GID_SUPPORT=OFF"
    # Musl lacks UTMP/WTMP built-in support
    ++ lib.optionals isMusl [
      "-DUTMP_SUPPORT=OFF"
      "-DWTMP_SUPPORT=OFF"
      "-DLASTLOG_SUPPORT=OFF"
    ];

  meta = {
    description = "OS independent and secure pty/tty and utmp/wtmp/lastlog";
    homepage = "http://dist.schmorp.de/libptytty";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2;
    # pkgsMusl.pkgsStatic errors as:
    #   ln: failed to create symbolic link './include': File exists
    broken = isStatic && isMusl;
  };

})
