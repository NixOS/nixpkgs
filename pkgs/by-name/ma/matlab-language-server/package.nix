{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "matlab-language-server";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "mathworks";
    repo = "matlab-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-02XMSegfWwiQCQc5a9MCD8S136NE4q6Xmb4Bv1u3s8A=";
  };

  npmDepsHash = "sha256-2KaCp0Hn+CfsiqQcbNZow7RDPc81zHJW4tcJDLUAzY0=";

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
