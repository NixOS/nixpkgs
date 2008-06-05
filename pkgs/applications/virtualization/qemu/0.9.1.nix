{stdenv, fetchurl, SDL, zlib, which}:

stdenv.mkDerivation {
  name = "qemu-0.9.1";

  src = fetchurl {
    url = http://bellard.org/qemu/qemu-0.9.1.tar.gz;
    sha256 = "199mb12w141yh2afzznh539jsip4h79kfsxwaj1xhzfwljsd0mj7";
  };

  patches = [../../../os-specific/linux/kvm/smbd-path.patch];

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
