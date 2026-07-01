{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "functionalplus";
  version = "0.2.28";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "FunctionalPlus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cXZGiiuxrsYic3PMLj4F7fTPfTsWugChrFqrzI6cLt4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Functional Programming Library for C++";
    homepage = "https://github.com/Dobiasd/FunctionalPlus";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
