{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "corestore";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "corestore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lbbjYWJah1A2/ySBTI2Mg78dRjLyt/TJ5rhqBPxWOps=";
  };

  npmDepsHash = "sha256-3WfcomAOE+u/ZIn5M+sP/GkxArXx5IRFzf0IG4ykaiU=";

  dontNpmBuild = true;

  # ERROR: Missing package-lock.json from src
  # Copy vendored package-lock.json to src via postPatch
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple corestore that wraps a random-access-storage module";
    homepage = "https://github.com/holepunchto/corestore";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ themadbit ];
    teams = with lib.teams; [ ngi ];
  };
})
