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
  meta = with lib; {
    description = "A suite of tools for emulating optical drives and discs";
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
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
