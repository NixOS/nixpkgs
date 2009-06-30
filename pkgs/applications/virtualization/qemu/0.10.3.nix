{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation {
  name = "qemu-0.10.3";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/qemu/qemu-0.10.3.tar.gz;
    sha256 = "0xxhyxa376vi4drjpqq21g0h6gqgb1fxamca7zinl2l8iix0sm49";
  };

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
