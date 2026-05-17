{
  lib,
  nodejs_22,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "browser-sync";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "BrowserSync";
    repo = "browser-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BDwd62ZLGUA262b0FLCFs3vo8wwgcy3k48YNugeLvtU=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  sourceRoot = "source/packages/browser-sync";

  nodejs = nodejs_22;

  npmDepsHash = "sha256-32IgL7kXCW1KwQhrb402Rqse5+ggo9K/fhxcp8pbwRc=";

  meta = {
    description = "Keep multiple browsers & devices in sync when building websites";
    homepage = "https://github.com/BrowserSync/browser-sync";
    maintainers = with lib.maintainers; [ wrvsrx ];
    license = lib.licenses.asl20;
    mainProgram = "browser-sync";
  };
})
