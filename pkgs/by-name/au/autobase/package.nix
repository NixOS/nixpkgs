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
  pname = "autobase";
  version = "7.19.2";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "autobase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IsqpVx7GFcbIouIAoLHiHLivE6RCzehW1TTmYC6SDgw=";
  };

  npmDepsHash = "sha256-H9Xy1VD7WQvi0+86v6CMcmc0L3mB6KuSCtgQSF4AlkY=";

  dontNpmBuild = true;

  # ERROR: Missing package-lock.json from src
  # https://github.com/holepunchto/autobase/issues/315
  # Copy vendored package-lock.json to src via postPatch
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru = {
    updateScriptSrc = gitUpdater {
      rev-prefix = "v";
    };
    updateScriptVendor = writeShellApplication {
      name = "update-autobase-lockfile-npmDepsHash";
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
    description = "Concise multiwriter for data structures with Hypercore";
    homepage = "https://github.com/holepunchto/autobase";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    teams = with lib.teams; [ ngi ];
  };
})
