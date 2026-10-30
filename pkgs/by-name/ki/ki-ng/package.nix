{
  lib,
  fetchFromGitHub,
  python3Packages,

  # dependencies
  anki,

  # tests
  gitMinimal,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ki-ng";
  version = "0.0.20a";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eljamm";
    repo = "ki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUKm5uWPPzSHwuSuDkHS06D9xMAl0jSsPoneXZn5OM8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = [
    anki
  ]
  ++ (with python3Packages; [
    beartype
    colorama
    git-filter-repo
    gitpython
    lark
    tqdm
    whatthepatch
  ]);

  pythonRelaxDeps = [
    "anki"
    "tqdm"
    "click"
    "beartype"
    "gitpython"
  ];

  nativeCheckInputs = with python3Packages; [
    bitstring
    checksumdir
    gitMinimal
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

  meta = {
    description = "Version control for Anki collections";
    homepage = "https://github.com/eljamm/ki";
    mainProgram = "ki";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
