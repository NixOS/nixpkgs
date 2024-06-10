{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  nodejs,
  bash,
  asar,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openasar";
  version = "0-unstable-2024-01-13";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "4f264d860a5a6a32e1862ce26178b9cf6402335d";
    hash = "sha256-NPUUDqntsMxnT/RN5M9DtLDwJXDyjOED4GlXa1oU8l8=";
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

  passthru.updateScript = unstableGitUpdater {
    # Only has a "nightly" tag (untaged version 0.2 is latest) see https://github.com/GooseMod/OpenAsar/commit/8f79dcef9b1f7732421235a392f06e5bd7382659
    hardcodeZeroVersion = true;
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
