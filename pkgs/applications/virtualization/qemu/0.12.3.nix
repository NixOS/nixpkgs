{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation rec {
  name = "qemu-0.12.3";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/qemu/${name}.tar.gz";
    sha256 = "0jyyz9vm8qrjb6nzfgdwmj9y990fnk2bl9ja0sr1i555n27nzqiw";
  };

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
