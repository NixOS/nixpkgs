{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "7.2.0";
  pname = "papi";

  src = fetchurl {
    url = "https://icl.utk.edu/projects/papi/downloads/papi-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
