{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gmp,
  ntl,
  cddlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "latte-integrale";
  version = "1.7.6";

  src = fetchurl {
    url = "https://github.com/latte-int/latte/releases/download/version_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/latte-int-${finalAttrs.version}.tar.gz";
    hash = "sha256-AGwQ6+XVv9ybFZy6YmSkQyhh/nY84F/oIWJKt9P8IXA=";
  };

  patches = [
    # C++17 compat
    (fetchpatch {
      url = "https://github.com/latte-int/latte/commit/6dbf7f07d5c9e1f3afe793f782d191d4465088ae.patch";
      excludes = [ "code/latte/sqlite/IntegrationDB.h" ];
      hash = "sha256-i7c11y54OLuJ0m7PBnhEoAzJzxC842JU7A6TOtTz06k=";
    })
  ];

  buildInputs = [
    gmp
    ntl
    cddlib
  ];

  meta = {
    description = "Software for counting lattice points and integration over convex polytopes";
    homepage = "https://www.math.ucdavis.edu/~latte/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = lib.platforms.unix;
  };
})
