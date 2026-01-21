{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "functionalplus";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "FunctionalPlus";
    rev = "v${version}";
    sha256 = "sha256-LlWdzxfFkbfkb9wAmpb86Ah97pWlW3w7DdW6JPu1xdc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Functional Programming Library for C++";
    homepage = "https://github.com/Dobiasd/FunctionalPlus";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
