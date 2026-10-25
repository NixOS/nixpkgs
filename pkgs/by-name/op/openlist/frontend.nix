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
  version = "4.2.9";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x9FQ5k2YpNGwU3xa6utHz5csHC6PdHKHDUY/uc/RN10=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-RkIRLA8Zc90lYYnZfWwR+gxBl1jj81OpXVLL5qQJT+c=";
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
    hash = "sha256-Hlz82KV41gpFx8BltxD/f4z0we4/KSMAtQdLo+V7WBM=";
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
