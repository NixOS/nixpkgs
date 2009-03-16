{stdenv, fetchsvn, SDL, zlib, which}:

stdenv.mkDerivation {
  name = "qemu-svn-6642";

  src = fetchsvn {
  	url = "svn://svn.sv.gnu.org/qemu/trunk";
	rev = "6642";
	sha256 = "12445ad91feb72eecd1db0d4319a8fa5d7dc971b89228bd0e121b49c5da9705e";
  };

  patchFlags = "-p2";
  
  buildInputs = [SDL zlib which];
  
  meta = {
    description = "QEmu processor emulator";
  };
}
