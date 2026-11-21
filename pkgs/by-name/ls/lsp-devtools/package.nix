{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  versionTagPrefix = "lsp-devtools-v";
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lsp-devtools";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "swyddfa";
    repo = "lsp-devtools";
    tag = "${versionTagPrefix}${finalAttrs.version}";
    hash = "sha256-HZJ73nubtPULxI/+De7Eagm4R55JIpDMIKJU6fGdQ2A=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib/lsp-devtools";

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiosqlite
    platformdirs
    pygls
    stamina
    textual
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=${versionTagPrefix}(.+)"
    ];
  };

  meta = {
    description = "CLI utilities that help inspect and visualise the interactions between a language client and a server";
    homepage = "https://lsp-devtools.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/swyddfa/lsp-devtools";
    changelog = "https://github.com/swyddfa/lsp-devtools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "lsp-devtools";
    platforms = lib.platforms.all;
  };
})
