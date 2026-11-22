{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchzip,

  nodejs,
  openlistPnpm ? pnpm_11,
  pnpmConfigHook,
  pnpm_11,
}:
buildNpmPackage (finalAttrs: {
  pname = "openlist-frontend";
  version = "4.2.10";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vR+2vhmJKw8VeG5eLGlu6sIC+XrvgPyEW6M60FlP/Qc=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-ekm55QngHhmOXcZpA0oFDD5CszrIr4Afr7VIiCz8n8Y=";
    stripRoot = false;
  };

  postPatch = ''
    cp -r ${finalAttrs.i18n}/* src/lang/
  '';

  nativeBuildInputs = [
    nodejs
    openlistPnpm
  ];

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = openlistPnpm;
    fetcherVersion = 4;
    hash = "sha256-nT5Zmh4MDnrY2FDiTpcAOcYFovmN4nJ8yQ4FBMmfrc8=";
  };

  npmConfigHook = pnpmConfigHook;

  # [plugin vite:legacy-generate-polyfill-chunk]
  # Error: getaddrinfo ENOTFOUND localhost
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    echo -n "v${finalAttrs.version}" > $out/VERSION

    runHook postInstall
  '';

  meta = {
    description = "Frontend of OpenList";
    homepage = "https://github.com/OpenListTeam/OpenList-Frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    inherit (nodejs.meta) platforms;
  };
})
