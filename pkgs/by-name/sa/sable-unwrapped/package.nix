{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_24,
  nix-update-script,
}:

let
  nodejs = nodejs_24;
  pnpm = pnpm_10.override { inherit nodejs; };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "sable-unwrapped";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "SableClient";
    repo = "Sable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zoGKs0pm9m42JrTNAdU33LP139JlVz3RZnkTyY0aiqY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-2GwUz0jsuVKQZyeidM0F4rDzijm9AFcAxN7x/m/b3Is=";
  };

  nativeBuildInputs = [
    nodejs
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
