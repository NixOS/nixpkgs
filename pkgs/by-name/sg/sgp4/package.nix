{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "sgp4";
  version = "unstable-2022-11-13";

  src = fetchFromGitHub {
    owner = "dnwrnr";
    repo = "sgp4";
    rev = "6a448b4850e5fbf8c1ca03bb5f6013a9fdc1fd91";
    hash = "sha256-gfJQOLhys5wKzZCxFVqbo+5l7jPeGPzrvYsdZKPSCJc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Simplified perturbations models library";
    homepage = "https://github.com/dnwrnr/sgp4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexwinter ];
    platforms = lib.platforms.unix;
  };
}
