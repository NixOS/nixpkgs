{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.11.0";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-su6nmpb+13rU1sOew0/tg9Rfy3WjHFiVaBPVjc8wsZ8=";
  };

  meta = {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = lib.licenses.asl20;
    maintainers = lib.teams.helsinki-systems.members;
    mainProgram = "mmdblookup";
    platforms = lib.platforms.all;
  };
}
