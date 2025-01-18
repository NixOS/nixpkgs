{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.12.0";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-5pB8whnIp8Cd0eQ+aEniRr5DA2OmHvFEtk1DeNdLfSE=";
  };

  meta = with lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = licenses.asl20;
    maintainers = teams.helsinki-systems.members;
    mainProgram = "mmdblookup";
    platforms = platforms.all;
  };
}
