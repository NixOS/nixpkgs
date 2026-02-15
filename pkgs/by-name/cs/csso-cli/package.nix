{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "csso-cli";
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "css";
    repo = "csso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EXdPgmqq35+8HWX0WcZsZF/XCDjFEAEStr36kwoWnWY=";
  };

  npmDepsHash = "sha256-TMwQjk/LN1jlP9Mh5UsO0X19f4wEBhz6Wnha6NdqyNA=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for CSSO, a CSS minifier with structural optimizations";
    homepage = "https://github.com/css/csso-cli";
    changelog = "https://github.com/css/csso-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "csso";
    maintainers = with lib.maintainers; [ ners ];
  };
})
