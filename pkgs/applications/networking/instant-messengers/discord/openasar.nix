{ lib, stdenv, fetchFromGitHub, nodejs, bash, nodePackages, unzip }:

stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2023-01-13";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "40b27dd1b8dd48277207db1b165c220c3441484c";
    hash = "sha256-tDJxcnbX0REu8DX+bQ7i4JzvLl6lRyB7+/dnAJI18Ss=";
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
    ${nodePackages.asar}/bin/asar pack src app.asar

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
