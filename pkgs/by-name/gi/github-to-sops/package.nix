{
  lib,
  fetchFromGitHub,
  python3Packages,
  sops,
  versionCheckHook,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "github-to-sops";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tarasglek";
    repo = "github-to-sops";
    tag = "v${version}";
    hash = "sha256-HwJay5GaEWhXBsRijSgxX+FMKX7wIwssDVoekPKJ67M=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = [
    sops
  ];

  patches = [
    ./use-compliant-license-schema.patch
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for managing infrastructure secrets in git repositories using SOPS and GitHub SSH keys";
    homepage = "https://github.com/tarasglek/github-to-sops";
    license = lib.licenses.mit;
    mainProgram = "github-to-sops";
    maintainers = with lib.maintainers; [ typedrat ];
  };
}
