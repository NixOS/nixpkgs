{ lib, stdenv, fetchurl, libgcrypt, libgpg-error, bison, flex }:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libaacs";
  version  = "0.11.1";

  src = fetchurl {
    url = "http://get.videolan.org/libaacs/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-qIqg6+TJinf3rv/ZKrPvZKxUjGuCLoJIqLkmclvqCjk=";
  };

  buildInputs = [ libgcrypt libgpg-error ];

  nativeBuildInputs = [ bison flex ];

  meta = with lib; {
    homepage = "https://www.videolan.org/developers/libaacs.html";
    description = "Library to access AACS protected Blu-Ray disks";
    mainProgram = "aacs_info";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; linux;
  };
}
