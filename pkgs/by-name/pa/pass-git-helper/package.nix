{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pass-git-helper";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "pass-git-helper";
    tag = "v${version}";
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

  meta = with lib; {
    homepage = "https://github.com/languitar/pass-git-helper";
    description = "Git credential helper interfacing with pass, the standard unix password manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      hmenke
    ];
    mainProgram = "pass-git-helper";
  };
}
