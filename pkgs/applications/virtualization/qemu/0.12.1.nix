{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation {
  name = "qemu-0.12.1";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/qemu/qemu-0.12.1.tar.gz;
    sha256 = "15frq26h2f847fiy1aivb3kj4psx8id8kw217781aimqlk9q45pf";
  };

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
