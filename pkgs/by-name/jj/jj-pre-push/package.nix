{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
}:

python3Packages.buildPythonApplication rec {
  pname = "jj-pre-push";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acarapetis";
    repo = "jj-pre-push";
    tag = "v${version}";
    hash = "sha256-/fh06T7kTlyyzj+ez9JkbU5h80Ez9B0nwZ/znjwTUJg=";
  };

  build-system = [
    python3Packages.uv-build
  ];

  dependencies = with python3Packages; [
    typer-slim
  ];

  pythonImportsCheck = [
    "jj_pre_push"
  ];

  meta = {
    description = "Run pre-commit.com before `jj git push`";
    homepage = "https://github.com/acarapetis/jj-pre-push";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "jj-pre-push";
  };
}
