{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "autobase";
  version = "7.17.3";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "autobase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RTbK1U63gNuUN81ceJVjFzqNtg0kfvfq8DiLEpDXJq0=";
  };

  npmDepsHash = "sha256-H9Xy1VD7WQvi0+86v6CMcmc0L3mB6KuSCtgQSF4AlkY=";

  dontNpmBuild = true;

  # ERROR: Missing package-lock.json from src
  # https://github.com/holepunchto/autobase/issues/315
  # Copy vendored package-lock.json to src via postPatch
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Concise multiwriter for data structures with Hypercore";
    homepage = "https://github.com/holepunchto/autobase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    teams = with lib.teams; [ ngi ];
  };
})
