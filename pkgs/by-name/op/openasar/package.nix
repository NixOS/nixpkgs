{
  lib,
  stdenv,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "openasar";
  version = "0-unstable-2025-09-17";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "bf8a71e2fcf1c77761092b7b899839164e3a596c";
    hash = "sha256-gKaqLIlEJUUTbXBQ0E97bHS6Z1HFdmEt8jsvkQH4hI8=";
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

  meta = with lib; {
    description = "Open-source alternative of Discord desktop's \"app.asar\"";
    homepage = "https://openasar.dev";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      Scrumplex
      jopejoe1
    ];
    platforms = nodejs.meta.platforms;
  };
})
