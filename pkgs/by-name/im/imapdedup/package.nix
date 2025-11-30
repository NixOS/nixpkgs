{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "imapdedup";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quentinsf";
    repo = "IMAPdedup";
    tag = version;
    hash = "sha256-CmWkLz9hdmedUxcojmUVTkPjqpaMmtEeHnF7aglKR+s=";
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
