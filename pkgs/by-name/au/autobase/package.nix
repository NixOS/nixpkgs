{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "autobase";
  version = "7.20.0";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "autobase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SEeCbNja5BIgpQh0q0LKo452JClKQe6do5YHwRRBMcs=";
  };

  npmDepsHash = "sha256-H9Xy1VD7WQvi0+86v6CMcmc0L3mB6KuSCtgQSF4AlkY=";

  dontNpmBuild = true;

  # ERROR: Missing package-lock.json from src
  # https://github.com/holepunchto/autobase/issues/315
  # Copy vendored package-lock.json to src via postPatch
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--generate-lockfile"
    ];
  };

  meta = {
    description = "Concise multiwriter for data structures with Hypercore";
    homepage = "https://github.com/holepunchto/autobase";
    license = lib.licenses.mit;
    maintainers = [ ];
    teams = with lib.teams; [ ngi ];
  };
})
