{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "imapdedup";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quentinsf";
    repo = "IMAPdedup";
    rev = "refs/tags/${version}";
    hash = "sha256-s49nnMjX1beZKTrlcjzp0nESIVRb/LZDycpnzz8fG+o=";
  };

  build-system = with python3Packages; [ hatchling ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "imapdedup" ];

  meta = {
    description = "Duplicate email message remover";
    homepage = "https://github.com/quentinsf/IMAPdedup";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = with lib.licenses; [ gpl2Only ];
    mainProgram = "imapdedup";
  };
}
