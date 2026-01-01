{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "makebootfat";
  version = "1.4";

  src = fetchurl {
    url = "mirror://sourceforge/advancemame/makebootfat-${version}.tar.gz";
    sha256 = "0v0g1xax0y6hmw2x10nfhchp9n7vqyvgc33gcxqax8jdq2pxm1q2";
  };

<<<<<<< HEAD
  meta = {
    description = "Create bootable USB disks using the FAT filesystem and syslinux";
    homepage = "http://advancemame.sourceforge.net/boot-readme.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Create bootable USB disks using the FAT filesystem and syslinux";
    homepage = "http://advancemame.sourceforge.net/boot-readme.html";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "makebootfat";
  };
}
