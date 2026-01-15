{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "csso-cli";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "css";
    repo = "csso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uPjRSBOFEl55gyObKEZMXGQ6eaQ3tBB48k5JgLGrbTw=";
  };

  npmDepsHash = "sha256-rGqj1vCswUfAQwM1Lk1qCWgUfzeefBONHeEn0NusOoc=";

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
