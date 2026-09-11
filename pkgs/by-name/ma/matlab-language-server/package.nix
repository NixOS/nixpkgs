{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "matlab-language-server";
  version = "1.3.16";

  src = fetchFromGitHub {
    owner = "mathworks";
    repo = "matlab-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yw3J6N8ICClrj/NdQSBveV0e/GNe2ZYVrjrGGwQNnh4=";
  };

  npmDepsHash = "sha256-ddqgG6416zNwH74d1VsyQRprDWBwrBpnX0AtCfJCMgs=";

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
