{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-web";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eHu12DcP2LFJaRBX6WEieucS0HkSi231ZtUSZlunCuo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-YOu0a/mR4PiRQx03BkPQbZgGQzgqXHy9DDihm8aD3wc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r dist/* $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web UI for OpenCloud built with Vue.js and TypeScript";
    homepage = "https://github.com/opencloud-eu/web";
    changelog = "https://github.com/opencloud-eu/web/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      christoph-heiss
      k900
    ];
    platforms = lib.platforms.all;
  };
})
