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
  version = "1.22.11";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "Sable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RwYKaJ4k2lqXjVSPN/o0Qw8GIGnXfb6acCpva36qQoM=";
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
    problems.removal = {
      message = "Sable 1 is no longer maintained upstream and has been succeeded by Sable 2, packaged as sable-next. Sable 2 migrates Sable 1 sessions on first start, see the migration notes before switching.";
      urls = [
        "https://github.com/SableClient/Sable#readme"
        "https://git.sable.moe/SableClient/sable-next/src/branch/main/docs/v1-v2-migration.md"
      ];
    };
  };
})
