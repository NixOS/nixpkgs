{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation {
  name = "qemu-0.12.2";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/qemu/qemu-0.12.2.tar.gz;
    sha256 = "0hv8fs8z14miryqm81vhlwwp4gmffw11lka7945rxn6vqzpc5kmc";
  };

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
