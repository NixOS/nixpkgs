{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pass-git-helper";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "pass-git-helper";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-gMhTYIFNCrUm6YoOOesJcQScugQ/SawiyeXjRG3cpQY=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ pyxdg ];

  env.HOME = "$TMPDIR";

  pythonImportsCheck = [ "passgithelper" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  meta = {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "Git credential helper interfacing with pass, the standard unix password manager";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      hmenke
    ];
    mainProgram = "pass-git-helper";
  };
})
