{
  lib,
  fetchFromGitHub,
  # Pinned to Python 3.12 because future-1.0.0 is not supported for Python 3.13:
  # error: future-1.0.0 not supported for interpreter python3.13
  python312Packages,
}:
python312Packages.buildPythonApplication rec {
  pname = "sccmhunter";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garrettfoster13";
    repo = "sccmhunter";
    rev = "v${version}";
    hash = "sha256-h7P+ry4J26Hm1s9U37t1EDWBaYRL32WA3sk8caA1edg=";
  };

  build-system = with python312Packages; [
    setuptools
  ];

  dependencies = with python312Packages; [
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
