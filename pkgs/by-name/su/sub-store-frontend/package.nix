{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
  nodejs,
}:
let
  pnpm = pnpm_11;
in
buildNpmPackage (finalAttrs: {
  pname = "sub-store-frontend";
  version = "2.34.2";

  src = fetchFromGitHub {
    owner = "sub-store-org";
    repo = "Sub-Store-Front-End";
    tag = finalAttrs.version;
    hash = "sha256-nrUtfYMbbNjGNllL56NogJb2wsvAR46uBkSl7S2SHYI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
  ];

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-FF3DaiYyPmdSRxT6iA+In+AeMswt0BUkVqAzTqYQ92Q=";
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
