{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cockpit-dockermanager";
  version = "1.0.8.2";

  src = fetchFromGitHub {
    owner = "chrisjbawden";
    repo = "cockpit-dockermanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NYRLlS9mk1OOlpX3L8ezl6Cvn2kP9+8YDLzuCb54pso=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cockpit
    cp -r $src/dockermanager $out/share/cockpit

    runHook postInstall
  '';

  passthru.cockpitPath = [ ];

  meta = {
    description = "Cockpit plugin for managing docker containers";
    homepage = "https://chrisjbawden.github.io/cockpit-dockermanager/";
    changelog = "https://chrisjbawden.github.io/cockpit-dockermanager/";
    maintainers = [ lib.maintainers.EpicEric ];
    platforms = lib.platforms.linux;
    license = [ lib.licenses.mit ];
  };
})
