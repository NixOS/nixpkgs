{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  replaceVars,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs_22,
  zip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suwayomi-webui";
  version = "1.5.1";
  revision = "2467";

  src = fetchFromGitHub {
    owner = "Suwayomi";
    repo = "Suwayomi-WebUI";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EKNuzMSPpNPjljHw5TmAeGfowi6mgdjsunqdRSLmAac=";
  };

  patches = [
    (replaceVars ./version.patch {
      inherit (finalAttrs) revision;
      inherit (nodejs_22) version;
    })
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-xNvPSpgJPesgCStiOqNT7pMUOZzfdb0u5xNJewiFD9A=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook

    nodejs_22
    zip
  ];

  postBuild = ''
    yarn --offline build-md5
    yarn --offline build-zip
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out/share -p
    cp buildZip/Suwayomi-WebUI-r${finalAttrs.revision}.zip $out/share/WebUI.zip

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "The client for Suwayomi-Server";
    homepage = "https://github.com/Suwayomi/Suwayomi-WebUI";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-WebUI/releases/";
    changelog = "https://github.com/Suwayomi/Suwayomi-WebUI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    inherit (nodejs_22.meta) platforms;
    maintainers = with lib.maintainers; [
      ratcornu
      nanoyaki
    ];
  };
})
