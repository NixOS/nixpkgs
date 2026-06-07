{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "smbclient-ng";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "smbclient-ng";
    tag = finalAttrs.version;
    hash = "sha256-W0f+PxPjI5raIjUNK7fcfPvFugrJxLZTWZPpX/6P56w=";
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
    changelog = "https://github.com/p0dalirius/smbclient-ng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smbclientng";
  };
})
