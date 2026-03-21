{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "dnsdiag";
  version = "2.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "farrokhi";
    repo = "dnsdiag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CMWjPgdYRL730AkC+PZaDAeefq9jCbO4o3RcdlIqsmU=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aioquic
    cryptography
    cymruwhois
    dnspython
    h2
    httpx
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "DNS Measurement, Troubleshooting and Security Auditing Toolset";
    homepage = "https://github.com/farrokhi/dnsdiag";
    changelog = "https://github.com/farrokhi/dnsdiag/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsdiag";
  };
})
