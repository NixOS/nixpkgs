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
  pname = "hypercore";
  version = "11.13.0";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hypercore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YaSmKjJKWkA4UUK/1LF9wqS4PvdFHrrc+yzvz+QmL0A=";
  };

  npmDepsHash = "sha256-ZJxVmQWKgHyKkuYfGIlANXFcROjI7fibg6mxIhDZowM=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru = {
    updateScriptSrc = gitUpdater {
      rev-prefix = "v";
    };
    updateScriptVendor = writeShellApplication {
      name = "update-hypercore-lockfile-npmDepsHash";
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
    description = "Secure, distributed append-only log";
    homepage = "https://github.com/holepunchto/hypercore";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.goodylove ];
    platforms = lib.platforms.all;
  };

})
