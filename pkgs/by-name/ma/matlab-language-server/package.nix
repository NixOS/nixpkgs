{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "matlab-language-server";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "mathworks";
    repo = "matlab-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VWL+frUgjz0N6k0bO0Wb/+ZjYz2P5zimHSEItI1FC98=";
  };

  npmDepsHash = "sha256-v6jnz6Qk7ao99Iw1PZnyGfvdbK+a7Mp6Jvjm5teVuDE=";

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
