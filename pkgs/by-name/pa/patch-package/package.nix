{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "patch-package";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "ds300";
    repo = "patch-package";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QuCgdQGqy27wyLUI6w6p8EWLn1XA7QbkjpLJwFXSex8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-WF9gJkj4wyrBeGPIzTOw3nG6Se7tFb0YLcAM8Uv9YNI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fix broken node modules instantly";
    mainProgram = "patch-package";
    homepage = "https://github.com/ds300/patch-package";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
