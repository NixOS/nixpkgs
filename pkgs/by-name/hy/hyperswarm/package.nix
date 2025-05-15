{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "hyperswarm";
  version = "4.11.7";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hyperswarm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z/FNBDJbiyR5AY40RDtiuQmjNUZ+BSGv8aewBnhSNZw=";
  };

  npmDepsHash = "sha256-4ysUYFIFlzr57J7MdZit1yX3Dgpb2eY0rdYnwyppwK0=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Distributed Networking Stack for Connecting Peers";
    homepage = "https://github.com/holepunchto/hyperswarm";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ];
  };
})
