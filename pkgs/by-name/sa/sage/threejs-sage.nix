{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "threejs-sage";
  version = "r122";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "threejs-sage";
    rev = finalAttrs.version;
    sha256 = "sha256-xPAPt36Fon3hYQq6SOmGkIyUzAII2LMl10nqYG4UPI0=";
  };

  installPhase = ''
    mkdir -p "$out/lib/node_modules/three/"
    cp version "$out/lib/node_modules/three"
    cp -r build "$out/lib/node_modules/three/$(cat version)"
  '';
})
