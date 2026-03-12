{
  stdenvNoCC,
  lib,
  opencloud,
  applyPatches,
  fetchpatch,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-idp-web";

  inherit (opencloud) version;

  src = applyPatches {
    src = opencloud.src;
    patches = [
      # Fixes broken kopano tarball, remove in next version
      (fetchpatch {
        url = "https://github.com/opencloud-eu/opencloud/commit/212846f2f4e23e89ed675e5a689d87ba1de55b70.patch";
        hash = "sha256-i+fkWTY4nrZ5fVGlQhhamxy9yrBL9OtDdm7CfV13oak=";
      })
    ];
  };

  pnpmRoot = "services/idp";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pnpmRoot}";
    fetcherVersion = 3;
    hash = "sha256-W5odz//dONpBg4eRQQoVrBMVsEQVkkP89hzMdIXxG7w=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
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
