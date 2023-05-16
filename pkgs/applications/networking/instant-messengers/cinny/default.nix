<<<<<<< HEAD
{ lib, buildNpmPackage, fetchFromGitHub, writeText, jq, conf ? { } }:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in
buildNpmPackage rec {
  pname = "cinny";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-Da/gbq9piKvkIMiamoafcRrqxF7128GXoswk2C43An8=";
  };

  npmDepsHash = "sha256-3wgB/dQmLtwxbRsk+OUcyfx98vpCvhvseEOCrJIFohY=";

  nativeBuildInputs = [
    jq
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"
=======
{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in stdenv.mkDerivation rec {
  pname = "cinny";
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/ajbura/cinny/releases/download/v${version}/cinny-v${version}.tar.gz";
    hash = "sha256-AvYM8++PqKmm7CJN5hmg9GSC72IoHX+rRxuT3GflvjU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/
    ${jq}/bin/jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with maintainers; [ abbe ];
<<<<<<< HEAD
    license = licenses.agpl3Only;
=======
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
