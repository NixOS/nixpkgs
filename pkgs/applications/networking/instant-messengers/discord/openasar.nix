{ lib, stdenv, fetchFromGitHub, nodejs, bash, nodePackages, unzip }:

let
  # OpenAsar fails with default unzip, throwing  "lchmod (file attributes) error: Operation not supported"
  unzipFix =
    if stdenv.isLinux then
      unzip.overrideAttrs (oldAttrs: {
        buildFlags = oldAttrs.buildFlags ++ [ "LOCAL_UNZIP=-DNO_LCHMOD" ];
      })
    else
      unzip;
in
stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2022-06-27";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "6f7505fb91a07035d3661a3a7bf68b3018ddfd82";
    sha256 = "2tb6OgYOnpryiyk7UH39sgzwtGJf9hNOpy74YqLI+Uk=";
  };

  postPatch = ''
    # Hardcode unzip path
    substituteInPlace ./src/updater/moduleUpdater.js \
      --replace \'unzip\' \'${unzipFix}/bin/unzip\'
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
