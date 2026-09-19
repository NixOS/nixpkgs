{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs-slim_24,
  nix-update-script,
}:

let
  nodejs-slim = nodejs-slim_24;
  pnpm = pnpm_10.override { inherit nodejs-slim; };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-unwrapped";
  version = "1.22.4";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "Sable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-15iUAT0C5b1qLv5pgBpzGsOGIH5dbgpmjQc0Z6uaRYY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-sI0tE73l+yKS8186tUHrNAJmGD26XEe7828ohvvc+1o=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm
  ];

  # Controls how the application displays its version, e.g. "v1.14.0 (nix)".
  # Also prevents some attempts to execute git during build.
  env = {
    VITE_IS_RELEASE_TAG = "true";
    VITE_BUILD_HASH = "nix";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An almost stable Matrix client";
    homepage = "https://github.com/SableClient/Sable";
    changelog = "https://github.com/SableClient/Sable/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      fugi
    ];
  };
})
