{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  openssh,
  openssl,
}:

buildGoModule rec {
  pname = "ssh-tpm-agent";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-CSxZctiQ/d4gzCUtfx9Oetb8s0XpHf3MPH/H0XaaVgg=";
  };

  proxyVendor = true;

  vendorHash = "sha256-84ZB1B+RczJS08UToCWvvVfWrD62IQxy0XoBwn+wBkc=";

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    openssh
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "SSH agent with support for TPM sealed keys for public key authentication";
    homepage = "https://github.com/Foxboron/ssh-tpm-agent";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sgo ];
    mainProgram = "ssh-tpm-agent";
  };
}
