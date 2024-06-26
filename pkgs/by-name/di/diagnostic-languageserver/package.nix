{
  lib,
  mkYarnPackage,
  fetchYarnDeps,
  fetchFromGitHub,
  nix-update-script
}: mkYarnPackage rec {
  pname = "diagnostic-languageserver";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "diagnostic-languageserver";
    rev = "v${version}";
    hash = "sha256-EFkvxMvtA5L6ZiDxrZxGnNAphNn/P3ra6ZrslplScZg=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-T8ppt8EDljtMhGp9i0VleU2Nw3tJexE2ufT6C4EtAz0=";
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postBuild
  '';
  doDist = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "General purpose Language Server that integrate with linter to support diagnostic features";
    homepage = "https://github.com/iamcco/diagnostic-languageserver";
    changelog = "https://github.com/iamcco/diagnostic-languageserver/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "diagnostic-languageserver";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
