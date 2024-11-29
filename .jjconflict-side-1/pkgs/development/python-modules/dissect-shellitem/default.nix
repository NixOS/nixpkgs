{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-shellitem";
  version = "3.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.shellitem";
    rev = "refs/tags/${version}";
    hash = "sha256-BS+c9QbMMsaoZHyuv6jMxbQFQNJeLt3da8Fq/wwXesQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.shellitem" ];

  disabledTests = [
    # Windows-specific tests
    "test_xp_remote_lnk_file"
    "test_xp_remote_lnk_dir"
    "test_win7_local_lnk_dir"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Shellitem structures";
    homepage = "https://github.com/fox-it/dissect.shellitem";
    changelog = "https://github.com/fox-it/dissect.shellitem/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "parse-lnk";
  };
}
