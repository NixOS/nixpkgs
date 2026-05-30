{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchzip,

  nodejs,
  openlistPnpm ? pnpm_10,
  pnpmConfigHook,
  pnpm_10,
}:
buildNpmPackage (finalAttrs: {
  pname = "openlist-frontend";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4WSL6j0dANUNlHFkMBb8j/KyNHWDQmLnC1y2FFJiBEI=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-VzHNZh0ZA2FncAkyozHeBilN4KKsPqbpMESx4QCppW0=";
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
    fetcherVersion = 3;
    hash = "sha256-rTDk1p568AKim+ZD00uq1q4XNNMeUFL1rGDBWx2C6DQ=";
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
