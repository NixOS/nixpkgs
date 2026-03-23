{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  pnpm_10,
  pnpm ? pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "sub-store-frontend";
  version = "2.16.21";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store-Front-End";
    tag = finalAttrs.version;
    hash = "sha256-3Ep7V6+vvhwuD4WYP6X8ga3PmPr+ItojCRYwqmVpuKs=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
  ];

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-HEeNYLKvzO/RQWYnm5gqRjTrXiiCxKUxf3bcRvz+O4k=";
  };

  npmConfigHook = pnpmConfigHook;

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sub-Store Progressive Web App";
    homepage = "https://github.com/sub-store-org/Sub-Store-Front-End";
    changelog = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    platforms = nodejs.meta.platforms;
  };
})
