{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctmg";
  version = "1.2";

  src = fetchzip {
    url = "https://git.zx2c4.com/ctmg/snapshot/ctmg-${finalAttrs.version}.tar.xz";
    sha256 = "1i4v8sriwjrmj3yizbl1ysckb711yl9qsn9x45jq0ij1apsydhyc";
  };

  installPhase = "install -D ctmg.sh $out/bin/ctmg";

  meta = {
    description = "Encrypted container manager for Linux using cryptsetup";
    homepage = "https://git.zx2c4.com/ctmg/about/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ mrVanDalo ];
    platforms = lib.platforms.linux;
    mainProgram = "ctmg";
  };
})
