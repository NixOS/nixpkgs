{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbirds";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "clainstone";
    repo = "cbirds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MMctTFtEUYt3xn7gFYWcMlRFLkFXW+wu6/hTtTkO6Og=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;
  checkTarget = "test";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flock of birds (Craig Reynolds' boids) in your terminal";
    homepage = "https://github.com/clainstone/cbirds";
    changelog = "https://github.com/clainstone/cbirds/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "cbirds";
    platforms = lib.platforms.unix;
  };
})
