{
  lib,
  buildNpmPackage,
  fetchurl,
  testers,
}:

let
  pname = "subfont";
  version = "7.2.1";
  src = fetchurl {
    url = "https://registry.npmjs.org/subfont/-/subfont-${version}.tgz";
    hash = "sha256-8zfMO/3zEKkLI7nZShVpaJxxueM8amdsiIEGmcebLgQ=";
  };
in
buildNpmPackage (finalAttrs: {
  inherit pname version src;

  npmDepsHash = "sha256-vqsm8/1I1HFo9IZdOqGQ/qFEyLTYY5uwtsnp1PJfPIk=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Command line tool to optimize webfont loading by aggressively subsetting based on font use, self-hosting of Google fonts and preloading";
    mainProgram = "subfont";
    homepage = "https://github.com/Munter/subfont";
    changelog = "https://github.com/Munter/subfont/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
