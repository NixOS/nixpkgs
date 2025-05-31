{
  stdenvNoCC,
  lib,
  opencloud,
  pnpm_10,
  nodejs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-idp-web";

  inherit (opencloud) version src;

  pnpmRoot = "services/idp";

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    hash = "sha256-gFhWDYk3DcwUowZ9AQjCqHZL1oniK3YCNiG1cDGabYg=";
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
