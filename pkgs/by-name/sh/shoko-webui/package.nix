{
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  pnpmConfigHook,
  lib,
  shoko,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shoko-webui";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "Shoko-WebUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/frP6qI5xAmogb5a5AA83IJxgOhVUi6X0E4h3Qg5u6w=";
  };

  # Avoid requiring git as a build time dependency. It's used for version
  # checking in the updater, which shouldn't be used if the webui is managed
  # declaratively anyway.
  patches = [ ./no-commit-hash.patch ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-rTlem83dFptgvKUKUaHK8vi5B0FBehPFtkCUhOnUKd0=";
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
    maintainers = with lib.maintainers; [
      diniamo
      nanoyaki
    ];
    inherit (shoko.meta) license platforms;
  };
})
