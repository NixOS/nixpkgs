{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-web";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "web";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fBtT5KRx+/9X+kZf7hvToXVB62+/RSrvDTMC0uv2Kk4=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-03HgyDdxoSgYfWBQkVLvCHM0P2BvgO7MaSsVNNddqP0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
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
