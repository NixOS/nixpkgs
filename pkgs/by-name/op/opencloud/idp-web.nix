{
  stdenvNoCC,
  lib,
  opencloud,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-idp-web";

  inherit (opencloud) src version;

  pnpmRoot = "services/idp";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    fetcherVersion = 3;
    hash = "sha256-p1hsRGSp/IwfxqwniqJc4c5pz5khYPW1g9WpfysEFnA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  buildPhase = ''
    runHook preBuild

    cd $pnpmRoot
    pnpm build
    mkdir -p assets/identifier/static
    cp -v src/images/favicon.svg assets/identifier/static/favicon.svg
    cp -v src/images/icon-lilac.svg assets/identifier/static/icon-lilac.svg

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r assets $out

    runHook postInstall
  '';

  meta = {
    description = "OpenCloud - IDP Web UI";
    homepage = "https://github.com/opencloud-eu/opencloud";
    changelog = "https://github.com/opencloud-eu/opencloud/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      christoph-heiss
      k900
    ];
    platforms = lib.platforms.all;
  };
})
