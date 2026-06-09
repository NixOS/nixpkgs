{
  stdenvNoCC,
  lib,
  opencloud,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  nodejs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-idp-web";

  inherit (opencloud) src version;

  pnpmRoot = "services/idp";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    fetcherVersion = 4;
    hash = "sha256-NN5MmWYQgaG4s8+mnLWo8EzOobACOnYhdwt4+/4kz9o=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpmBuildHook
    pnpm_11
  ];

  postBuild = ''
    mkdir -p services/idp/assets/identifier/static
    cp -v services/idp/src/images/favicon.svg services/idp/assets/identifier/static/favicon.svg
    cp -v services/idp/src/images/icon-lilac.svg services/idp/assets/identifier/static/icon-lilac.svg
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r services/idp/assets $out

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
