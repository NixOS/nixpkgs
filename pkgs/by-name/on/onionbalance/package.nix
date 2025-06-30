{
  lib,
  python313Packages,
  fetchFromGitLab,
}:

python313Packages.buildPythonPackage rec {
  pname = "onionbalance";
  version = "0.2.4";
  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo";
    repo = "onion-services/onionbalance";
    rev = "36938bf60cc71745fc9ac7b44a79ec9c06ac620e";
    sha256 = "sha256-amwKP9LJ7aHPECNUNTluFpgIFSRLxR7eHQxBxW5574I=";
  };
  propagatedBuildInputs = with python313Packages; [
    cryptography
    pycryptodomex
    pyyaml
    setproctitle
    stem
  ];

  meta = {
    description = "tool for loadbalancing onion services";
    homepage = "https://github.com/torproject/onionbalance";
    changelog = "https://github.com/torproject/onionbalance/blob/${version}/docs/changelog.md";
    licence = lib.licences.gpl3Plus;
    maintainers = [ lib.maintainers.ForgottenBeast ];
    mainProgram = "onionbalance";
  };
}
