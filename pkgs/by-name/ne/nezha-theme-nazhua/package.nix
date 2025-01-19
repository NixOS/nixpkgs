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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "hi2shark";
    repo = "nazhua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5XEdfUCwQSa+PWu4SHJCg3rCtblyD5x41lKe0SvFrU8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Wy4xtLjDNkBLeESJCbfq9GhT0mSTAfGBN0A3oHX5BuE=";
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
