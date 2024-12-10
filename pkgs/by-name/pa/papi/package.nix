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
}
