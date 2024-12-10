{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  openssl,
}:

buildGo122Module rec {
  pname = "ssh-tpm-agent";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-8CGSiCOcns4cWkYWqibs6hAFRipYabKPCpkhxF4OE8w=";
  };

  proxyVendor = true;

  vendorHash = "sha256-zUAIesBeuh1zlxXcjKSNmMawZGgUr9z3NzT0XKn/YCQ=";

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "SSH agent with support for TPM sealed keys for public key authentication";
    homepage = "https://github.com/Foxboron/ssh-tpm-agent";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sgo ];
    mainProgram = "ssh-tpm-agent";
  };
}
