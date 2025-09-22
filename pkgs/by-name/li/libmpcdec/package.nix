{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmpcdec";
  version = "1.2.6";

  src = fetchurl {
    url = "https://files.musepack.net/source/libmpcdec-${version}.tar.bz2";
    sha256 = "1a0jdyga1zfi4wgkg3905y6inghy3s4xfs5m4x7pal08m0llkmab";
  };

  # needed for cross builds
  configureFlags = [ "ac_cv_func_memcmp_working=yes" ];

  meta = {
    description = "Musepack SV7 decoder library";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
}
