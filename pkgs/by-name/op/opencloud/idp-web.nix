{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  pnpm_10,
  nodejs,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-idp-web";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "opencloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nw2R+CdtsI9S0f7Xif9Ea5zOM5ZS5HzPUAMFBlHrJhA=";
  };

  pnpmRoot = "services/idp";

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    hash = "sha256-q0s6+79ogttyvT3R4se8Ec6dRDWNU1E6ChLfy0hbLbE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  buildPhase = ''
    runHook preBuild
    cd $pnpmRoot
    pnpm build
    mkdir -p assets/identifier/static
    cp -v src/images/favicon.ico assets/identifier/static/favicon.ico
    cp -v src/images/icon-lilac.svg assets/identifier/static/icon-lilac.svg
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r assets $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenCloud - IDP Web UI";
    homepage = "https://github.com/opencloud-eu/opencloud";
    changelog = "https://github.com/opencloud-eu/opencloud/blob/v${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    platforms = lib.platforms.all;
  };
})
