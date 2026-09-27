{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  pnpm_10_latest,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
  nodejs,
}:
let
  pnpm = pnpm_10_latest;
in
buildNpmPackage (finalAttrs: {
  pname = "sub-store-frontend";
  version = "2.34.0";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store-Front-End";
    tag = finalAttrs.version;
    hash = "sha256-jphgUjJouLky6jxTSk+6YBbwaNTV7+/oTu2RXc3UNk0=";
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
    hash = "sha256-EV6NpYQV9kQ4/2j012r0x66o5L9lNAYNvc5wI7DXiAU=";
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
