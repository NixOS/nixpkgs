{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage {
  pname = "acltoolkit";
  version = "0.2.2-unstable-2023-02-03";
  pyproject = true;

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

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
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

  meta = {
    description = "ACL abuse swiss-knife";
    mainProgram = "acltoolkit";
    homepage = "https://github.com/zblurx/acltoolkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
