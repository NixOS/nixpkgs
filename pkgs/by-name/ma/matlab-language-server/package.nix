{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "matlab-language-server";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "mathworks";
    repo = "matlab-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDtgommUDZbrTIGvH8xQyV+qNeDkxwwsx/0uQgGECPM=";
  };

  npmDepsHash = "sha256-BW2J8yTGegugvPxmj1i1K/GDc5bZH8sHOpLOPgwFGKg=";

  npmBuildScript = "package";

  meta = {
    description = "Language Server for MATLAB® code";
    homepage = "https://github.com/mathworks/MATLAB-language-server";
    changelog = "https://github.com/mathworks/MATLAB-language-server/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "matlab-language-server";
  };
})
