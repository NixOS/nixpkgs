{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certsync";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zblurx";
    repo = "certsync";
    tag = version;
    hash = "sha256-UNeO9Ldf6h6ykziKVCdAoBIzL5QedbRLFEwyeWDCtUU=";
  };

  pythonRelaxDeps = [ "certipy-ad" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    certipy-ad
    tqdm
  ];

  pythonImportsCheck = [ "certsync" ];

  meta = with lib; {
    description = "Dump NTDS with golden certificates and UnPAC the hash";
    homepage = "https://github.com/zblurx/certsync";
    changelog = "https://github.com/zblurx/certsync/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "certsync";
  };
}
