{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "sccmhunter";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garrettfoster13";
    repo = "sccmhunter";
    rev = "v${version}";
    hash = "sha256-Db+kBLy2ejIKKjCskAE4arppk/sq9qQ3w1nCQmeLYhs=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    cmd2
    cryptography
    impacket
    ldap3
    pandas
    pyasn1
    pyasn1-modules
    requests
    requests-ntlm
    requests-toolbelt
    rich
    tabulate
    typer
    urllib3
    pyopenssl
    pycryptodome
  ];

  meta = {
    description = "Post exploitation tool to identify and attack SCCM related assets in an Active Directory domain";
    homepage = "https://github.com/garrettfoster13/sccmhunter";
    changelog = "https://github.com/garrettfoster13/sccmhunter/blob/${src.rev}/changelog.md";
    license = lib.licenses.mit;
    mainProgram = "sccmhunter.py";
    maintainers = with lib.maintainers; [ purpole ];
  };
}
