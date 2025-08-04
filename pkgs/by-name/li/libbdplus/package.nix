{
  lib,
  stdenv,
  fetchurl,
  libgcrypt,
  libgpg-error,
  gettext,
}:

# library that allows libbluray to play BDplus protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libbdplus";
  version = "0.2.0";

  src = fetchurl {
    url = "http://get.videolan.org/libbdplus/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-uT7qPq7zPW6RVdLDSwaMUFSTqlpJNuYydPQ0KrD0Clg=";
  };

  buildInputs = [
    libgcrypt
    libgpg-error
    gettext
  ];

  meta = {
    homepage = "http://www.videolan.org/developers/libbdplus.html";
    description = "Library to access BD+ protected Blu-Ray disks";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = with lib.platforms; unix;
  };
}
