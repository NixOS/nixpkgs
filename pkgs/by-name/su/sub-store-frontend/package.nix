{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
  nodejs,
}:
let
  pnpm = pnpm_10;
in
buildNpmPackage (finalAttrs: {
  pname = "sub-store-frontend";
  version = "2.29.10";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store-Front-End";
    tag = finalAttrs.version;
    hash = "sha256-jQXIwdt9+yndTFBCrs6bZ7dCZ2fmjti0xQAgAGZbC1M=";
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
    hash = "sha256-Pr0l1JxHvpsgfsvQdENbxLehBAn7/X87lPxsbKfNBw0=";
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
