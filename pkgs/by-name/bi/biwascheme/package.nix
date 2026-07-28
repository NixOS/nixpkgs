{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "biwascheme";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "biwascheme";
    repo = "biwascheme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X3spl/myhcfmnJ1pN7RAoR0rc4kEM9s0DLtrN9RqyhU=";
  };

  npmDepsHash = "sha256-jVLCR6gIgK5OhH/KQPn3lYdTuNpMAEAQS1EtqIq8jTM=";

  postPatch = ''
    substituteInPlace rollup.config.js \
      --replace-fail "git rev-parse HEAD" "echo ${finalAttrs.version}"
  '';

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scheme interpreter written in JavaScript";
    homepage = "https://github.com/biwascheme/biwascheme";
    changelog = "https://github.com/biwascheme/biwascheme/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "biwas";
  };
})
