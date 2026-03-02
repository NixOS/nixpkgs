{
  lib,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "metacubexd";
  version = "1.241.3";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "metacubexd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oR8rhD/wPgm14rG5ic8Dx4WNCnpmxapzUWomqAC3708=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    hash = "sha256-UVf9ti4Cu4IACQQ16g7R6pIArJUUVn2XOC7CjXMMS9I=";
  };

  buildPhase = ''
    runHook preBuild

    export NUXT_TELEMETRY_DISABLED=1
    export NUXT_APP_BASE_URL='./'

    pnpm generate

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./.output/public $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clash.Meta Dashboard, The Official One, XD";
    homepage = "https://github.com/MetaCubeX/metacubexd";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
})
