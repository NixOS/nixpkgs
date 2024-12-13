{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  openssl,
}:

buildGoModule rec {
  pname = "ssh-tpm-agent";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-yK7G+wZIn+kJazKOFOs8EYlRWZkCQuT0qZfmdqbcOnM=";
  };

  proxyVendor = true;

  vendorHash = "sha256-njKyBfTG/QCPBBsj3Aom42cv2XqLv4YeS4DhwNQNaLA=";

  buildInputs = [
    openssl
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
