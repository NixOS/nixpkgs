{ lib
, buildGoModule
, fetchFromGitHub
, openssl
}:

buildGoModule rec {
  pname = "ssh-tpm-agent";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-J9qX6DQH8hOzO+MKiehUmnmJ58/yvpvQdfNGJTXa8TI=";
  };

  proxyVendor = true;

  vendorHash = "sha256-l80dUfaqsN2ZnUmGgIYzcYO6p+cSs9NhK9vc6tLDmyk=";

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
