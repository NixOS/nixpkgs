{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
}:

python3Packages.buildPythonApplication rec {
  pname = "jj-pre-push";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acarapetis";
    repo = "jj-pre-push";
    tag = "v${version}";
    hash = "sha256-9HyVWxYmemF/K3ttQ0L1lZF/XFkSeqwli/Mm+FFI8lQ=";
  };

  patches = [
    # https://github.com/acarapetis/jj-pre-push/pull/2
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/Prince213/jj-pre-push/commit/aa2d917ec9560318178fbc1040281228db7b7ec1.patch?full_index=1";
      hash = "sha256-uNqOO0yVHShcXxYMPFcPCDM5YlL4IcmpUAfClmDlJ4Q=";
    })
  ];

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
