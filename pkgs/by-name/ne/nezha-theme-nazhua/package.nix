{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "nezha-theme-nazhua";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hi2shark";
    repo = "nazhua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lyrkWJDMMMellM8lIaZMvxXJT54gjjP4gnwxMcytrdA=";
  };

  npmDepsHash = "sha256-V+fdXp2QevPRYQQ4j5w9OQro6w3qnyi7imhgzGdUiVs=";

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
