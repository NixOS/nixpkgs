{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbclient-ng";
  version = "2.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "smbclient-ng";
    tag = version;
    hash = "sha256-gZbXtgxB5GkypU6U2oe9miobBbwnz/eXs/yWkzVUCcc=";
  };

  pythonRelaxDeps = [
    "impacket"
    "pefile"
    "rich"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    charset-normalizer
    impacket
    pefile
    rich
  ];

  # Project has no unit tests
  doCheck = false;

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
