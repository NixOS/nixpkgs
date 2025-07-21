{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "7.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "git-delete-merged-branches";
    tag = version;
    sha256 = "sha256-2MSdUpToOiurtiL0Ws2dLEWqd6wj4nQ2RsEepBytgAk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    colorama
    prompt-toolkit
  ];

  nativeCheckInputs = [ git ] ++ (with python3Packages; [ parameterized ]);

  meta = with lib; {
    description = "Command-line tool to delete merged Git branches";
    homepage = "https://github.com/hartwork/git-delete-merged-branches/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
