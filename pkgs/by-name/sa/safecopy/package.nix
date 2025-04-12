{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "safecopy";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/safecopy/safecopy/safecopy-${version}/safecopy-${version}.tar.gz";
    sha256 = "1zf4kk9r8za9pn4hzy1y3j02vrhl1rxfk5adyfq0w0k48xfyvys2";
  };

  meta = {
    description = "Data recovery tool for damaged hardware";

    longDescription = ''
      Safecopy is a data recovery tool which tries to extract as much data as possible from a
      problematic (i.e. damaged sectors) source - like floppy drives, hard disk partitions, CDs,
      tape devices, etc, where other tools like dd would fail due to I/O errors.

      Safecopy includes a low level IO layer to read CDROM disks in raw mode, and issue device
      resets and other helpful low level operations on a number of other device classes.
    '';

    homepage = "https://safecopy.sourceforge.net";

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bluescreen303 ];
    mainProgram = "safecopy";
  };
}
