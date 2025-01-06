{
  lib,
  stdenv,
  fetchurl,
  perl,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "atool";
  version = "0.39.0";

  src = fetchurl {
    url = "mirror://savannah/atool/atool-${version}.tar.gz";
    sha256 = "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b";
  };

  buildInputs = [ perl ];
  configureScript = "${bash}/bin/bash configure";

  meta = {
    homepage = "https://www.nongnu.org/atool";
    description = "Archive command line helper";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
    mainProgram = "atool";
  };
}
