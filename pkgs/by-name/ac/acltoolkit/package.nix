{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "acltoolkit";
  version = "unstable-2023-02-03";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zblurx";
    repo = "acltoolkit";
    rev = "a5219946aa445c0a3b4a406baea67b33f78bca7c";
    hash = "sha256-97cbkGyIkq2Pk1hydMcViXWoh+Ipi3m0YvEYiaV4zcM=";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i -e "s/==[0-9.]*//" setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    asn1crypto
    dnspython
    impacket
    ldap3
    pyasn1
    pycryptodome
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "acltoolkit"
  ];

  meta = with lib; {
    description = "ACL abuse swiss-knife";
    mainProgram = "acltoolkit";
    homepage = "https://github.com/zblurx/acltoolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
