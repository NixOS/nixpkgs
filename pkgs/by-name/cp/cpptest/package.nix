{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpptest";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/cpptest/cpptest/cpptest-${finalAttrs.version}/cpptest-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-bKrKAU/QBl74KAkw9kWbfjXapxq6t+wgnP0aLzCd9oM=";
  };

  meta = {
    homepage = "http://cpptest.sourceforge.net/";
    description = "Simple C++ unit testing framework";
    maintainers = with lib.maintainers; [ bosu ];
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
  };
})
