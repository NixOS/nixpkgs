{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  fetchYarnDeps,
  nodejs,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nezha-theme-nazhua";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hi2shark";
    repo = "nazhua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zzdfttj6yURNgB0uS1DtwIREWbd88+oIkgiupjw/8oA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-/CQsG3iQdPyKHdApeMzq4w90NsMBdLXUP2lya8vtK5Q=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  # Copied from .github/workflows/release.yml
  env = {
    VITE_NEZHA_VERSION = "v1";
    VITE_SARASA_TERM_SC_USE_CDN = "1";
    VITE_USE_CDN = "1";
    VITE_CDN_LIB_TYPE = "jsdelivr";
  };

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nezha monitoring theme called Nazhua";
    changelog = "https://github.com/hi2shark/nazhua/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/hi2shark/nazhua";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
