{
  buildNpmPackage,
  fetchzip,
  lib,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "angular-cli";
  version = "22.3.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/@angular/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-mwcG9tLSGxN8cJZvat39PgWSy9wf/I+BMdvnz6eCh24=";
  };

  npmDepsHash = "sha256-9hjv7kJGV/Ipm4prkeG7hH3Q/Fit4uNbNaK6B6xoJe8=";

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
