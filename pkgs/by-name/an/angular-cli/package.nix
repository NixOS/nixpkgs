{
  buildNpmPackage,
  fetchzip,
  lib,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "angular-cli";
  version = "22.2.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/@angular/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-M7v7B2vimDYdlZZI4/M67O2lMytXnj46KSRInML8k78=";
  };

  npmDepsHash = "sha256-pDp8IPY7ZV/1RRJNqCshh+3GwgQiViwb77/g8+dLgWg=";

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
