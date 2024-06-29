{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  nix-update-script
}:

mkYarnPackage rec {
  pname = "patch-package";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "ds300";
    repo = "patch-package";
    rev = "v${version}";
    hash = "sha256-QuCgdQGqy27wyLUI6w6p8EWLn1XA7QbkjpLJwFXSex8=";
  };

  packageJSON = "${src}/package.json";
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-WF9gJkj4wyrBeGPIzTOw3nG6Se7tFb0YLcAM8Uv9YNI=";
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fix broken node modules instantly";
    mainProgram = "patch-package";
    homepage = "https://github.com/ds300/patch-package";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
