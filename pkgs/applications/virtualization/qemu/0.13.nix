{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation rec {
  name = "qemu-0.13.0";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/qemu/${name}.tar.gz";
    sha256 = "0xyqbwy78218ja6r9ya5p37j8hcd81l4cpw3ghvnxsjwn18mhvqy";
  };
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
