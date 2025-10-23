{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pyxdg,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  setuptools,
}:

buildPythonApplication rec {
  pname = "pass-git-helper";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "pass-git-helper";
    tag = "v${version}";
    sha256 = "sha256-SAMndgcxBa7wymXbOwRGcoogFfzpFFIZ0tF4NSCXpjw=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyxdg ];

  env.HOME = "$TMPDIR";

  pythonImportsCheck = [ "passgithelper" ];

  nativeCheckInputs = [
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
