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
  version = "1.235.3";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "metacubexd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3CtXD8fG/JEK13VcovjckrtPLTQUltut1AOk2nufdCc=";
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
    hash = "sha256-cT0HGAc/eu7LMZp4/MNRgodo+nkhLoN5yOWfcrtsr5I=";
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
