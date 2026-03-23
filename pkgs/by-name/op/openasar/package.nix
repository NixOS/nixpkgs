{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  nodejs,
  asar,
  unzip,
  discord,
  discord-ptb,
  discord-canary,
  discord-development,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openasar";
  version = "0-unstable-2026-03-04";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "a75870297df907d43ac6565385b0af4a781cf6fe";
    hash = "sha256-tEKt2Qfk29HP448keMb7JR4+iTR3AXCho7PdkF0D1i0=";
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
    substituteInPlace src/index.js --replace 'nightly' '${finalAttrs.version}'
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

  passthru = {
    updateScript = unstableGitUpdater {
      # Only has a "nightly" tag (untaged version 0.2 is latest) see https://github.com/GooseMod/OpenAsar/commit/8f79dcef9b1f7732421235a392f06e5bd7382659
      hardcodeZeroVersion = true;
    };
    tests = lib.genAttrs' [ discord discord-ptb discord-canary discord-development ] (
      p: lib.nameValuePair p.pname p.tests.withOpenASAR
    );
  };

  meta = {
    description = "Open-source alternative of Discord desktop's \"app.asar\"";
    homepage = "https://openasar.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      Scrumplex
      jopejoe1
    ];
    platforms = nodejs.meta.platforms;
  };
})
