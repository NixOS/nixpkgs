{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsdiag";
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "farrokhi";
    repo = "dnsdiag";
    tag = "v${version}";
    hash = "sha256-hKtGJItz+Ipo5i7jNzD3EYHchGsy15IN/4w1a1gK1jM=";
  };

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
    changelog = "https://github.com/farrokhi/dnsdiag/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsdiag";
  };
}
