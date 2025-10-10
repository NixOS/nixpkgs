{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  libpq,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soci";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "SOCI";
    repo = "soci";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vdvvqPTODC0AMDLZa2pOy5/qkZ1IuJ0PEDTN6oMJAqg=";
  };

  # Do not build static libraries
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "11")
    (lib.cmakeBool "SOCI_STATIC" false)
    (lib.cmakeBool "SOCI_TESTS" false)
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    sqlite
    libpq
    boost
  ];

  meta = {
    description = "Database access library for C++";
    homepage = "https://soci.sourceforge.net/";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jluttine ];
  };
})
