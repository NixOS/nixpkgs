{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "beangrep";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zacchiro";
    repo = "beangrep";
    tag = finalAttrs.version;
    hash = "sha256-hYvjCJguWcvn4VEbfWpa3uWhxynB88ec2rXY3x2YGYQ=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    beancount
    click
  ];

  pythonImportsCheck = [
    "beangrep"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "grep-like filter for Beancount";
    homepage = "https://github.com/zacchiro/beangrep";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "bean-grep";
  };
})
