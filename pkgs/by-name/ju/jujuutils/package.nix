{
  lib,
  stdenv,
  fetchurl,
  linuxHeaders,
}:

stdenv.mkDerivation rec {
  pname = "jujuutils";
  version = "0.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jujuutils/jujuutils-${version}.tar.gz";
    sha256 = "1r74m7s7rs9d6y7cffi7mdap3jf96qwm1v6jcw53x5cikgmfxn4x";
  };

  buildInputs = [ linuxHeaders ];

  meta = {
    homepage = "https://github.com/cladisch/linux-firewire-utils";
    description = "Utilities around FireWire devices connected to a Linux computer";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
