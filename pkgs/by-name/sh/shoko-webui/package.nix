{
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  lib,
  shoko,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shoko-webui";
  version = "2.5.9";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "Shoko-WebUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mHBflHehCnwCkh4K271vo30rfoQa+3xLos0d7P/kKvE=";
  };

  # Avoid requiring git as a build time dependency. It's used for version
  # checking in the updater, which shouldn't be used if the webui is managed
  # declaratively anyway.
  patches = [ ./no-commit-hash.patch ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-0ZXXfP6iHyd5zlUQruS3MZADkuucygXrUPRKNCNYA7k=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  passthru.updateSript = nix-update-script {
    extraArgs = [
      "--version-regex"
      ''v([0-9]+\.[0-9]+\.[0-9]+).*''
    ];
  };

  meta = {
    homepage = "https://github.com/ShokoAnime/Shoko-WebUI";
    changelog = "https://github.com/ShokoAnime/Shoko-WebUI/releases/tag/v${finalAttrs.version}";
    description = "Web-based frontend for the Shoko anime management system";
    maintainers = with lib.maintainers; [ nanoyaki ];
    inherit (shoko.meta) license platforms;
  };
})
