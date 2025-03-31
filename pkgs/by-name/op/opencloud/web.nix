{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-web";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A5TWyB07+XmB8ctQnim93+1P1TjBWGEI5ATODhZm3FY=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QiJDqFhZQIJAZyr18zHtMfJULOlPRYm1T3nL3OOHkk4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
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
    changelog = "https://github.com/opencloud-eu/web/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.all;
  };
})
