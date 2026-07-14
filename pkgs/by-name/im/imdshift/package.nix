{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "imdshift";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ayushpriya10";
    repo = "IMDShift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uoa0uNOhCkT622Yy8GEg8jz9k5zmtXwGmvdb3MVTLX8=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    boto3
    click
    prettytable
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "IMDShift"
  ];

  meta = {
    description = "Tool to migrate workloads to IMDSv2";
    mainProgram = "imdshift";
    homepage = "https://github.com/ayushpriya10/IMDShift";
    changelog = "https://github.com/ayushpriya10/IMDShift/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
