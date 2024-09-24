{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  nodejs,
  asar,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openasar";
  version = "0-unstable-2024-09-06";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "f92ee8c3dc6b6ff9829f69a1339e0f82a877929c";
    hash = "sha256-V2oZ0mQbX+DHDZfTj8sV4XS6r9NOmJYHvYOGK6X/+HU=";
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
