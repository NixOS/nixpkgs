{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "autobase";
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "autobase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YKNb2lpSQgH4bDZmA4qJzUFSeJFHXJZseMEml/JxD+s=";
  };

  npmDepsHash = "sha256-oorYb9i/prb/5Jt/hNQcq/NPQq/kAhI2KU8d28nPv/0=";

  dontNpmBuild = true;

  # ERROR: Missing package-lock.json from src
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
