{ stdenv, fetchurl, SDL, zlib, which, ncurses }:

stdenv.mkDerivation rec {
  name = "qemu-0.13.0";

  src = fetchurl {
    url = "mirror://savannah/releases/qemu/${name}.tar.gz";
    sha256 = "0xyqbwy78218ja6r9ya5p37j8hcd81l4cpw3ghvnxsjwn18mhvqy";
  };

  buildInputs = [ SDL zlib which ncurses ];

  meta = {
    description = "QEmu processor emulator";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
