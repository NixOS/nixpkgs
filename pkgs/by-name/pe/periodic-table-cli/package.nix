{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
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

  npmDepsHash = "sha256-36TjC+80gaU15UvkY9Ssc8sBoThsyclN1z8ux5b53Cc=";
  dontNpmBuild = true;
  forceEmptyCache = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  preInstall = ''
    mkdir node_modules/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive Periodic Table of Elements app for the console";
    homepage = "https://github.com/spirometaxas/periodic-table-cli";
    changelog = "https://github.com/spirometaxas/periodic-table-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nouritsu ];
    mainProgram = "periodic-table-cli";
  };
})
