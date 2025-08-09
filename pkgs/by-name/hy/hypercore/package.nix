{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "hypercore";
  version = "11.11.2";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hypercore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vDI1j5seR6OBp64wq9oy4eVrtlJF7OCiQb+2EEdOGXw=";
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
