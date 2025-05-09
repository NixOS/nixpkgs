{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "hypercore";
  version = "11.6.2";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hypercore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o4Ojja+8Yvn1fK9FszcH/wHZnuyhpHxsch0D1kb5HlE=";
  };

  npmDepsHash = "sha256-lBV5IehqP2qOe3/mJjLJt8Ty77QN8uUGc5oolFUEqck=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure, distributed append-only log";
    homepage = "https://github.com/holepunchto/hypercore.git";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.goodylove ];
    platforms = lib.platforms.all;
    mainProgram = "hypercore";
  };

})
