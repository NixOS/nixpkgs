{
  lib,
  stdenv,
  fetchurl,
  libgcrypt,
  libgpg-error,
  bison,
  flex,
}:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation (finalAttrs: {
  pname = "libaacs";
  version = "0.12.0";

  src = fetchurl {
    url = "https://get.videolan.org/libaacs/${finalAttrs.version}/libaacs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-GZZnOp/EXuSjZMZv+oR1Zim/OSPlI0bHNYtxvsuORBk=";
  };

  buildInputs = [
    libgcrypt
    libgpg-error
  ];

  nativeBuildInputs = [
    bison
    flex
  ];

  meta = {
    homepage = "https://www.videolan.org/developers/libaacs.html";
    description = "Library to access AACS protected Blu-Ray disks";
    mainProgram = "aacs_info";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
