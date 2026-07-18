{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "matlab-language-server";
  version = "1.3.12";

  src = fetchFromGitHub {
    owner = "mathworks";
    repo = "matlab-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+0aVg5SesV8zOndRLTpz3WwLW32GxLLVlMcWj46vVIM=";
  };

  npmDepsHash = "sha256-SQtUgX3yNXwUxZxPvNdYAtLBAu++2DiAx301X0LnAQo=";

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
