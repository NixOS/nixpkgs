{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "har-to-k6";
  version = "0.14.13";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "har-to-k6";
    tag = "v${version}";
    hash = "sha256-RKg8ShzxxIaK6mmcmLjYT8Ofe2CM3U5/Lg/UEIRi30Q=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-Z5aq9apwz1wvm0uam2pxzX+T+hKkk/kmXPy7IyrUHFM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Converts LI-HAR and HAR to K6 script";
    homepage = "https://github.com/grafana/har-to-k6";
    changelog = "https://github.com/grafana/har-to-k6/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cterence ];
    mainProgram = "har-to-k6";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
