{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation {
  name = "qemu-0.11.0";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/qemu/qemu-0.11.0.tar.gz;
    sha256 = "1w3n61lzwvqg1ygn0vs8syybbmbcbk7lfyya098k201lp5rpwamw";
  };

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
