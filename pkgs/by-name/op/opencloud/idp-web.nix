{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-idp-web";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "opencloud";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2CsPDKLi61CPNkXi6pxuymhi8WvIuQa0OPMHE4jY428=";
  };

  pnpmRoot = "services/idp";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    hash = "sha256-0XGMMQxNpYuh774netjtQnnlJ1n+1e/amx5gw1ZTBNw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
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
