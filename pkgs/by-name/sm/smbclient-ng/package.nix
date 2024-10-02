{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbclient-ng";
  version = "2.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "smbclient-ng";
    rev = "refs/tags/${version}";
    hash = "sha256-5ObqmCvMoBuQOPbQATrIVzxnxrJtvB+iUJSS7sqs6hI=";
  };

  pythonRelaxDeps = [
    "impacket"
    "pefile"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    charset-normalizer
    impacket
    pefile
    rich
  ];

  pythonImportsCheck = [ "smbclientng" ];

  meta = {
    description = "Tool to interact with SMB shares";
    homepage = "https://github.com/p0dalirius/smbclient-ng";
    changelog = "https://github.com/p0dalirius/smbclient-ng/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smbclientng";
  };
}
