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
  version = "1.273.1";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "metacubexd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F6gjJLmkYUJCcRhT59QzLd5mB6yxQfz5Gh/Ca39cvR4=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-DEucFNqpd8y2pO+Kb1hIL3OwS8uM+mWFStaYp4RS1uo=";
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
