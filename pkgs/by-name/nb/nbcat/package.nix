{
  lib,
  python3Packages,
  versionCheckHook,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "nbcat";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "akopdev";
    repo = "nbcat";
    tag = "v${version}";
    hash = "sha256-DD5/KPKdz1VgPWZqjal98UrbACoVvEls/LnMY1AYRdw=";
  };

  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    argcomplete
    markdownify
    pydantic
    requests
    rich
    textual
    textual-image
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Preview Jupyter notebooks directly in your terminal. Like cat but for `.ipynb` files!";
    homepage = "https://github.com/akopdev/nbcat";
    mainProgram = "nbcat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Tygo-van-den-Hurk
    ];
  };
}
