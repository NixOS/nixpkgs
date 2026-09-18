{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "gofish";
  version = "1.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/gofish/gofish/${finalAttrs.version}/gofish-${finalAttrs.version}.tar.gz";
    sha256 = "0br5nvlna86k4ya4q13gz0i7nlmk225lqmpfiqlkldxkr473kf0s";
  };

  meta = {
    description = "Lightweight Gopher server";
    homepage = "https://gofish.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
