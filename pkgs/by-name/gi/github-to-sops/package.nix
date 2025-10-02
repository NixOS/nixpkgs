{
  lib,
  fetchFromGitHub,
  fetchpatch2,
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
    (fetchpatch2 {
      name = "use-compliant-license-schema.patch";
      url = "https://github.com/tarasglek/github-to-sops/commit/798c864f1537f668fbaf7802651ec8beb998a7af.patch?full_index=1";
      hash = "sha256-udBO5dN8RCclXpkTj/gU6zcUcaoM+G9jPEw4dCZ+oT4=";
    })
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
