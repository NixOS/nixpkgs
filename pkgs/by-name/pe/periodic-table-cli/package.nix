{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "periodic-table-cli";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "spirometaxas";
    repo = "periodic-table-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0b6JQWIH9BpfpeMDlsnxwsg1ai4xyCosmIphtYdTR5E=";
  };

  # package has no external deps
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    mkdir -p node_modules
  '';
  forceEmptyCache = true;
  dontNpmBuild = true;
  npmDepsHash = "sha256-36TjC+80gaU15UvkY9Ssc8sBoThsyclN1z8ux5b53Cc=";

  meta = {
    description = "An interactive Periodic Table of Elements app for the console!";
    homepage = "https://github.com/spirometaxas/periodic-table-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nouritsu ];
    mainProgram = "periodic-table-cli";
  };
})
