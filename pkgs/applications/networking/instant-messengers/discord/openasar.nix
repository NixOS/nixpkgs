{ lib, stdenv, fetchFromGitHub, nodejs, bash, nodePackages, unzip }:

stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2022-12-11";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "0b1d4685cb2c94f42441fc616eb24e69eda04647";
    hash = "sha256-cRYXgVgA5B9MaDGJIACJYjFNDAMajReKud0akiGBR4Q=";
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
