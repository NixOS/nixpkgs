{
  lib,
  nodejs_22,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "browser-sync";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "BrowserSync";
    repo = "browser-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQZfSdzAGsLnZf7q5YWy5v4W4Iv3f0s4eOV1tC7yhXw=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  sourceRoot = "source/packages/browser-sync";

  nodejs = nodejs_22;

  npmDepsHash = "sha256-HvV7zaD8EZiXR7S7fZRT3zDpUxa3B9Gza9fl8zEurLA=";

  meta = {
    description = "Keep multiple browsers & devices in sync when building websites";
    homepage = "https://github.com/BrowserSync/browser-sync";
    maintainers = with lib.maintainers; [ wrvsrx ];
    license = lib.licenses.asl20;
    mainProgram = "browser-sync";
  };
})
