{ lib, stdenv, fetchFromGitHub, unstableGitUpdater, nodejs, bash, asar, unzip }:

stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2023-10-24";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "eee9bab822e3dbd97a735d0050ddd41ba27917f2";
    hash = "sha256-SSWQSqGgTZjowgrzF6qHZDTw/Y9xFHNTZvetxqZubYI=";
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
    ${asar}/bin/asar pack src app.asar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install app.asar $out

    runHook postInstall
  '';

  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    # Only has a "nightly" tag (untaged version 0.2 is latest) see https://github.com/GooseMod/OpenAsar/commit/8f79dcef9b1f7732421235a392f06e5bd7382659
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Open-source alternative of Discord desktop's \"app.asar\".";
    homepage = "https://openasar.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = nodejs.meta.platforms;
  };
}
