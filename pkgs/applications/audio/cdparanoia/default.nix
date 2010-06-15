{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cdparanoia-III-alpha9.8";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-alpha9.8.src.tgz;
    md5 = "7218e778b5970a86c958e597f952f193";
  };

  NO_PARALLEL_BUILD_buildPhase = 1;
  
  patches = [./fix.patch];

  meta = {
    homepage = http://xiph.org/paranoia;
  };
}
