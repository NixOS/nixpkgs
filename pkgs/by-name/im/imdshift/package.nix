{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "imdshift";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ayushpriya10";
    repo = "IMDShift";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uoa0uNOhCkT622Yy8GEg8jz9k5zmtXwGmvdb3MVTLX8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    description = "Tool to migrate workloads to IMDSv2";
    mainProgram = "imdshift";
    homepage = "https://github.com/ayushpriya10/IMDShift";
    changelog = "https://github.com/ayushpriya10/IMDShift/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
