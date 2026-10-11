{
  buildNpmPackage,
  fetchzip,
  lib,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "angular-cli";
  version = "22.2.2";

  src = fetchzip {
    url = "https://registry.npmjs.org/@angular/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-p6MI4kfFNB0ku85PpX2TRkd/s/dt9wXTLAmx+mMyTyo=";
  };

  npmDepsHash = "sha256-qobItnQdwgNqjSXaX2w9sH2iM1/f+HIQ/Mm8hUQI+vM=";

  strictDeps = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for Angular";
    homepage = "https://github.com/angular/angular-cli";
    changelog = "https://github.com/angular/angular-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "ng";
  };
})
