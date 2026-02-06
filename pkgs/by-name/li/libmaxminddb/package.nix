{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.12.2";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/libmaxminddb-${version}.tar.gz";
    sha256 = "sha256-G/v477o+1kYuBOIlkGrVzl/pWKo9YmoSNbKiJT1gB0M=";
  };

  meta = {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = lib.licenses.asl20;
    mainProgram = "mmdblookup";
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
    platforms = lib.platforms.all;
  };
}
