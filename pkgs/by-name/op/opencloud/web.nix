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
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vUDkE1rF30r6guuQIb2XLnaq+1NsyjS5L319AfCzJvA=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-uaQTWytTHsQP19IHUIXccGkx8StIjMZ3MgepRydeims=";
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
