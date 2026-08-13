{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.13.3";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/libmaxminddb-${version}.tar.gz";
    sha256 = "sha256-pmUC6nbq2+F/LNb9cIlGd3JTly0q6BV97hsjovtSgXE=";
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
