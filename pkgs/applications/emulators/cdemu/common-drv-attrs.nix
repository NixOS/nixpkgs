{
  lib,
  fetchurl,
  pname,
  version,
  hash,
}:

{
  inherit pname version;
  src = fetchurl {
    url = "mirror://sourceforge/cdemu/${pname}-${version}.tar.xz";
    inherit hash;
  };
<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Suite of tools for emulating optical drives and discs";
    longDescription = ''
      CDEmu consists of:

      - a kernel module implementing a virtual drive-controller
      - libmirage which is a software library for interpreting optical disc images
      - a daemon which emulates the functionality of an optical drive+disc
      - textmode and GTK clients for controlling the emulator
      - an image analyzer to view the structure of image files

      Optical media emulated by CDemu can be mounted within Linux. Automounting is also allowed.
    '';
    homepage = "https://cdemu.sourceforge.io/";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
