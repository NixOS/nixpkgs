{
  lib,
  python313Packages,
  fetchFromGitLab,
}:

python313Packages.buildPythonApplication rec {
  pname = "onionbalance";
  version = "0.2.4";

  pyproject = true;
  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo";
    repo = "onion-services/onionbalance";
    rev = version;
    hash = "sha256-amwKP9LJ7aHPECNUNTluFpgIFSRLxR7eHQxBxW5574I=";
  };
  propagatedBuildInputs = with python313Packages; [
    cryptography
    pycryptodomex
    pyyaml
    setproctitle
    stem
  ];
  build-system = with python313Packages; [
    setuptools
  ];

  meta = {
    description = "Tool for loadbalancing onion services";
    homepage = "https://github.com/torproject/onionbalance";
    changelog = "https://github.com/torproject/onionbalance/blob/${version}/docs/changelog.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.ForgottenBeast ];
    mainProgram = "onionbalance";
  };
}
