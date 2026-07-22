{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pass-git-helper";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "pass-git-helper";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-/Brx86YRmSkSr00xj5B5J/bNBqknoXRwX9B6595dEwU=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ pyxdg ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

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
      ibbem
    ];
    mainProgram = "pass-git-helper";
  };
})
