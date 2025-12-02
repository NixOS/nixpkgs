{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "corestore";
  version = "7.4.7";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "corestore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/UhiuEBoAJc1U2/VYVWLyEGcXUndH0QmM++FN4KCTHo=";
  };

  npmDepsHash = "sha256-hQYvQeTwlIWImdNhgpnJjDC24Fx4G0eST7tptWV1Xgw=";

  dontNpmBuild = true;

  # ERROR: Missing package-lock.json from src
  # Upstream doesn't want to maintain a lockfile in their repo: https://github.com/holepunchto/corestore/issues/119
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
