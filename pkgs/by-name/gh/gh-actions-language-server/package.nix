{
  lib,
  buildNpmPackage,
  fetchurl,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "gh-actions-language-server";
  version = "0.0.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/gh-actions-language-server/-/gh-actions-language-server-${finalAttrs.version}.tgz";
    hash = "sha256-lgisfGIWGT/WCGqOfm/rqSXVeDWqSge2YJ+ZiBMmS48=";
  };

  # The npm registry tarball doesn't include a package-lock.json.
  # We generate and maintain one locally to ensure reproducible builds.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-mu4ZmokeQzQMRzDobMzXkdAlOTNm/ahHYERi1n+By3c=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for GitHub Actions workflows";
    homepage = "https://github.com/actions/languageservices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "gh-actions-language-server";
  };
})
