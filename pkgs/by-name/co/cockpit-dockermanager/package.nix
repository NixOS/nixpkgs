{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cockpit-dockermanager";
  version = "1.0.9.1";

  src = fetchFromGitHub {
    owner = "chrisjbawden";
    repo = "cockpit-dockermanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-guqyXG9X/bvtethpAQmsp8HTVAhnHAAP+sEriqaaGbc=";
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
