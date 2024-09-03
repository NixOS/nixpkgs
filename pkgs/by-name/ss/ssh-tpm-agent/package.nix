{ lib
, buildGoModule
, fetchFromGitHub
, openssl
}:

buildGoModule rec {
  pname = "ssh-tpm-agent";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-gO9qVAVCvaiLrC/GiTJ0NghiXVRXXRBlvOIVSAOftR8=";
  };

  proxyVendor = true;

  vendorHash = "sha256-Upq8u5Ip0HQW5FGyqhVUT6rINXz2BpCE7lbtk9fPaWs=";

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
