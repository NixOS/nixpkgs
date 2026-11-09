{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "rea";
  version = "6.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "morluto";
    repo = "rea";
    tag = "rea-agents-${finalAttrs.version}";
    hash = "sha256-2ADn3U3lvUoB4tCEpzO0rMfYE4sis+5uBiEazcp0gpI=";
  };

  npmDepsHash = "sha256-3WPXD+qm5WVfrTEvepKwX5RZBfbLBcPB0uDmKIx4MR8=";

  npmFlags = [ "--ignore-scripts" ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"node": "^22.23.4 || ^24.22.1 || >=26.12.1"' '"node": "^22.23.4 || ^24.21.0 || >=26.12.1"' \
      --replace-fail '"prepack": "node scripts/prepack.mjs"' '"prepack": "true"' \
      --replace-fail '"prepare": "node scripts/prepare.mjs"' '"prepare": "true"'

    substituteInPlace src/domain/runtimeVersion.ts \
      --replace-fail '"^22.23.4 || ^24.22.1 || >=26.12.1"' '"^22.23.4 || ^24.21.0 || >=26.12.1"'

    substituteInPlace scripts/run-typescript.mjs \
      --replace-fail '? "tsrs"' '? "typescript"'
  '';

  npmBuildScript = "compile";

  postBuild = ''
    npm run artifacts:skills
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Reverse engineer anything from the terminal or agent with one CLI and MCP server";
    homepage = "https://github.com/morluto/rea";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnrtitor ];
    mainProgram = "rea";
  };
})
