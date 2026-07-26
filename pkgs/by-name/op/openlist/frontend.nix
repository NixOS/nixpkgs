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
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-33W0JCAmt3pjhAAOxoaZS7zBbJJbl4i85fqyKzoibz8=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-nnsnYXbH4Uq+sux11txanUs11MB2dHIT0vCLMIzYQdg=";
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
    hash = "sha256-V+YhQsfUvd8WHxIYEjuihEjTZE75eFfziq2GwW1rPbg=";
  };

  npmConfigHook = pnpmConfigHook;

  # [plugin vite:legacy-generate-polyfill-chunk]
  # Error: getaddrinfo ENOTFOUND localhost
  __darwinAllowLocalNetworking = true;

  preBuild = ''
    rm -rf node_modules/mpegts.js
    cp -R ${finalAttrs.passthru.mpegts-js}/lib/node_modules/mpegts.js node_modules/mpegts.js
    chmod -R u+w node_modules/mpegts.js
    test -f node_modules/mpegts.js/dist/mpegts.js
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    echo -n "v${finalAttrs.version}" > $out/VERSION

    runHook postInstall
  '';

  passthru = {
    # OpenList depends on a forked mpegts.js git package whose source does not include the generated dist/
    mpegts-js = buildNpmPackage {
      pname = "mpegts-js-openlist";
      version = "1.8.1-unstable-2026-05-16";

      src = fetchFromGitHub {
        owner = "OpenListTeam";
        repo = "mpegts.js";
        rev = "1e51e0f6f918cf08e05dfae9c7bfcf658d6b4ac2";
        hash = "sha256-z+S3iSYqrMuxFRGa5JZIfGMyi7IErpnluwZUVLxqz2o=";
      };

      npmDepsHash = "sha256-UDI0iPK/ouVgpzscGrQXNnVUseLWYmR0W9THpBm4WqA=";

      meta.license = lib.licenses.asl20;
    };
  };

  meta = {
    description = "Frontend of OpenList";
    homepage = "https://github.com/OpenListTeam/OpenList-Frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    inherit (nodejs.meta) platforms;
  };
})
