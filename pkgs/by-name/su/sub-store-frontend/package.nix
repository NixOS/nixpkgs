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
  version = "2.34.1";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store-Front-End";
    tag = finalAttrs.version;
    hash = "sha256-LQww3UvscvsymA9eI1i7HfxutK0lqXifWT47VJUHGOc=";
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
