{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "supervise";
  version = "1.4.0";

  src = fetchzip {
    url = "https://github.com/catern/supervise/releases/download/v${finalAttrs.version}/supervise-${finalAttrs.version}.tar.gz";
    sha256 = "0jk6q2f67pfs18ah040lmsbvbrnjap7w04jjddsfn1j5bcrvs13x";
  };

  meta = {
    homepage = "https://github.com/catern/supervise";
    description = "Minimal unprivileged process supervisor making use of modern Linux features";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
})
