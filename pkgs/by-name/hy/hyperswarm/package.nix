{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gitUpdater,
  writeShellApplication,
  _experimental-update-script-combinators,
  nix,
  nodejs,
  prefetch-npm-deps,
}:

buildNpmPackage (finalAttrs: {
  pname = "hyperswarm";
  version = "4.12.1";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hyperswarm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BQ1/kNJAFoxPJ2I3dyV7EHafKfbbDqCQw039VT4YLT8=";
  };

  npmDepsHash = "sha256-4ysUYFIFlzr57J7MdZit1yX3Dgpb2eY0rdYnwyppwK0=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru = {
    updateScriptSrc = gitUpdater {
      rev-prefix = "v";
    };
    updateScriptVendor = writeShellApplication {
      name = "update-hyperswarm-lockfile-npmDepsHash";
      runtimeInputs = [
        nix
        nodejs
        prefetch-npm-deps
      ];
      text = lib.strings.readFile ./updateVendor.sh;
    };
    updateScript = _experimental-update-script-combinators.sequence [
      finalAttrs.passthru.updateScriptSrc.command
      (lib.getExe finalAttrs.passthru.updateScriptVendor)
    ];
  };

  meta = {
    description = "Distributed Networking Stack for Connecting Peers";
    homepage = "https://github.com/holepunchto/hyperswarm";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ];
  };
})
