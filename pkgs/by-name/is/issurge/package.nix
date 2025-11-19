{
  lib,
  fetchFromGitHub,
  python3Packages,
  gh,
  glab,
}:

python3Packages.buildPythonApplication rec {
  pname = "issurge";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gwennlbh";
    repo = "issurge";
    tag = "v${version}";
    hash = "sha256-kpiI3WFqbQdJDXQCrjAalN7Fv4deLh0yH8+AlW+U8hI=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    docopt
    rich
  ];

  buildInputs = [
    gh
    glab
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        gh
        glab
      ]
    }"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [
    "issurge"
  ];

  meta = {
    description = "Deal with your client's feedback efficiently by creating a bunch of issues in bulk from a text file";
    homepage = "https://github.com/gwennlbh/issurge";
    changelog = "https://github.com/gwennlbh/issurge/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwennlbh ];
    mainProgram = "issurge";
  };
}
