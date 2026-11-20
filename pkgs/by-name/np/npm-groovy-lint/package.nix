{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  versionCheckHook,
  jdk,
}:

buildNpmPackage (finalAttrs: {
  pname = "npm-groovy-lint";
  version = "19.0.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nvuillam";
    repo = "npm-groovy-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nw1ZALCvmGWLiB6a3Z+iabStvdsups7E4tB3hqWufQI=";
  };

  npmDepsHash = "sha256-6iHmP70xtHkz8jhRppgDN1Z92R2xRrm++AjXQVEMgmE=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ jdk ])
  ];

  meta = {
    description = "Lint, format and auto-fix your Groovy / Jenkinsfile / Gradle files using command line";
    homepage = "https://github.com/nvuillam/npm-groovy-lint";
    changelog = "https://github.com/nvuillam/npm-groovy-lint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "npm-groovy-lint";
    platforms = lib.platforms.all;
  };
})
