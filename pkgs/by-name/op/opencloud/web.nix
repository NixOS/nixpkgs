{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencloud-web";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m02qZS2au6gH0D009Mt8H2qKp2VdVxSIT0q3RKRkh8U=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-wHrVBb/um7+6prBTzc30MXMCtERgGFV0mGvfS19tyTI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
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
    changelog = "https://github.com/opencloud-eu/web/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      christoph-heiss
      k900
    ];
    platforms = lib.platforms.all;
  };
})
