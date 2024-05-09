{ lib
, fetchFromGitHub
, python3Packages
, cmake
, anki
}:

python3Packages.buildPythonApplication rec {
  pname = "ki";
  version = "0-unstable-2023-11-08";

  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langfield";
    repo = pname;
    rev = "eb32fbd3229dc1a60bcc76a937ad63f3eb869f65";
    sha256 = "sha256-5mQhJhvJQC9835goL3t3DRbD+c4P3KxnOflxvqmxL58=";
  };

  patches = [
    ./update-to-newer-anki-versions.patch
    ./replace-deprecated-distutils-with-setuptools.patch
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = with python3Packages; [
    beartype
    click
    colorama
    git-filter-repo
    gitpython
    lark
    tqdm
    whatthepatch
  ] ++ [
    anki
  ];

  nativeCheckInputs = with python3Packages; [
    bitstring
    checksumdir
    gitpython
    loguru
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # requires git to not be in path, but git is needed for other tests
    "test_clone_cleans_up_on_error"
    "test_clone_clean_up_preserves_directories_that_exist_a_priori"
  ];

  dontCheckRuntimeDeps = true;

  # CMake needs to be run by pyproject rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    description = "Version control for Anki collections";
    homepage = "https://github.com/langfield/ki";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eljamm ];
  };
}
