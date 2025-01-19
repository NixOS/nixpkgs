{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "7.0.1";
  pname = "papi";

  src = fetchurl {
    url = "https://bitbucket.org/icl/papi/get/papi-${
      lib.replaceStrings [ "." ] [ "-" ] version
    }-t.tar.gz";
    sha256 = "sha256-VajhmPW8sEJksfhLjBVlpBH7+AZr4fwKZPAtZxRF1Bk=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */src)
  '';

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://icl.utk.edu/papi/";
    description = "Library providing access to various hardware performance counters";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      costrouc
      zhaofengli
    ];
  };
}
