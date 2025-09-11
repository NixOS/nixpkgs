{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "915resolution";
  version = "0.5.3";

  src = fetchurl {
    url = "http://915resolution.mango-lang.org/915resolution-${version}.tar.gz";
    hash = "sha256-tkyrg0teQQvKVV3J245p9i9vAklpQvNf9KaPPyfxtUI=";
  };

  patchPhase = "rm *.o";
  installPhase = "mkdir -p $out/sbin; cp 915resolution $out/sbin/";

  meta = {
    homepage = "http://915resolution.mango-lang.org/";
    description = "Tool to modify Intel 800/900 video BIOS";
    mainProgram = "915resolution";
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.publicDomain;
  };
}
