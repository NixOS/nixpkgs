{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsrs2";
  version = "1.0.18";

  src = fetchurl {
    url = "https://www.libsrs2.net/srs/libsrs2-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-nRGRtwXXWHpYhnNomQAdBBaDkru27WNFoFet5QlDpJI=";
  };

  meta = {
    description = "Next generation SRS library from the original designer of SRS";
    mainProgram = "srs";
    license = with lib.licenses; [
      gpl2
      bsd3
    ];
    homepage = "https://www.libsrs2.net/";
    platforms = lib.platforms.linux;
  };
})
