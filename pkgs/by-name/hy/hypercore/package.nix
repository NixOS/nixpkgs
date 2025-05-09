{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "hypercore";
  version = "11.7.0";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hypercore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZAKWFSOIAQysK9+4YxbUiL0fVsqnGFqhwe9ps6ZXYv0=";
  };

  npmDepsHash = "sha256-ZJxVmQWKgHyKkuYfGIlANXFcROjI7fibg6mxIhDZowM=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure, distributed append-only log";
    homepage = "https://github.com/holepunchto/hypercore";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.goodylove ];
    platforms = lib.platforms.all;
  };

})
