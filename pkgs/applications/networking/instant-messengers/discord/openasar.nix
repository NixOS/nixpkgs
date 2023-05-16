<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, nodejs, bash, asar, unzip }:

stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2023-07-07";
=======
{ lib, stdenv, fetchFromGitHub, nodejs, bash, nodePackages, unzip }:

stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2023-05-01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
<<<<<<< HEAD
    rev = "5ac246dc92e9a2a9b314d899df728f37096c482b";
    hash = "sha256-ODeVru4LCSl3rIeJCdezAwqzKP6IRo5WDaaUymqEcBs=";
=======
    rev = "a8b07392808032f95ac3a7c5856e76d2619c91ae";
    hash = "sha256-moHeSrWvVOb9+vNhC2YunjTC3Ojh10APt/tvG/AuNco=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Hardcode unzip path
    substituteInPlace ./src/updater/moduleUpdater.js \
      --replace \'unzip\' \'${unzip}/bin/unzip\'
    # Remove auto-update feature
    echo "module.exports = async () => log('AsarUpdate', 'Removed');" > ./src/asarUpdate.js
  '';

  buildPhase = ''
    runHook preBuild

    bash scripts/injectPolyfills.sh
    substituteInPlace src/index.js --replace 'nightly' '${version}'
    ${nodejs}/bin/node scripts/strip.js
<<<<<<< HEAD
    ${asar}/bin/asar pack src app.asar
=======
    ${nodePackages.asar}/bin/asar pack src app.asar
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install app.asar $out

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "Open-source alternative of Discord desktop's \"app.asar\".";
    homepage = "https://openasar.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ pedrohlc ];
    platforms = nodejs.meta.platforms;
  };
}
