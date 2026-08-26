{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage (finalAttrs: {
  pname = "actions-languageserver";
  version = "0.3.61";

  src = fetchurl {
    url = "https://registry.npmjs.org/@actions/languageserver/-/languageserver-${finalAttrs.version}.tgz";
    hash = "sha256-0VJyUGTGT4YtpRWM1jDUxnlz7ftYvauqRAVP/vA7nQM=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-vqXvtYcBek2R6ZCWDKJiBEyoUMXx8MZTJQRUlIBbSKI=";

  dontNpmBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Language server for GitHub Actions";
    homepage = "https://github.com/actions/languageservices/tree/main/languageserver";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tyceherrman ];
    mainProgram = "actions-languageserver";
  };
})
