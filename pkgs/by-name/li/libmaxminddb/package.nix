{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.12.2";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-G/v477o+1kYuBOIlkGrVzl/pWKo9YmoSNbKiJT1gB0M=";
  };

  meta = with lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = licenses.asl20;
    teams = [ teams.helsinki-systems ];
    mainProgram = "mmdblookup";
    platforms = platforms.all;
  };
}
