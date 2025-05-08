{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "7.1.0";
  pname = "papi";

  src = fetchurl {
    url = "http://icl.utk.edu/projects/papi/downloads/papi-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-WBivttuj7OV/UeZYl9tQYvjjRk5u0pS2VOvzTDmRvE8=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */src)
  '';

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    homepage = "https://icl.utk.edu/papi/";
    description = "Library providing access to various hardware performance counters";
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      costrouc
      zhaofengli
    ];
  };
})
