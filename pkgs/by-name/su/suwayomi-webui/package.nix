{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_24,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  _experimental-update-script-combinators,
  nix-update-script,

  nodejs ? nodejs_24,
  pnpm ? pnpm_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suwayomi-webui";
  version = "20260726.01";
  revision = "3379";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Suwayomi";
    repo = "Suwayomi-WebUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1eYVgoYSBX2ZHTZUXi0TN17m1UresEfdTc4Sq8rykbU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    pnpmBuildHook
  ];

  buildInputs = [
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-tbaNDI2kJKwriZGaSgqQAKPAB8ser53Nc6J4Jp6aqFY=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "project" "suwayomi-webui"
  '';

  postBuild = ''
    npm run build-md5
  '';

  installPhase = ''
    runHook preInstall

    cp -a build $out

    runHook postInstall
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    {
      command = [
        ./update-rev.sh
        finalAttrs.src.rev
      ];
    }
  ];

  meta = {
    description = "The default client for Suwayomi-Server";
    homepage = "https://github.com/Suwayomi/Suwayomi-WebUI";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-WebUI/releases/";
    changelog = "https://github.com/Suwayomi/Suwayomi-WebUI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    inherit (nodejs.meta) platforms;
    maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
  };
})
