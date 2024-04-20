{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "cert-viewer";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mgit-at";
    repo = "cert-viewer";
    rev = "refs/tags/v${version}";
    hash = "sha256-6IPr2BG3y/7cmc2WkeeFDpQ59GNU1eOhhm49HE2w0cA=";
  };

  vendorHash = "sha256-jNT04bYH5L/Zcfvel673zr2UJLayCO443tvBGZjrBZk=";

  meta = {
    description = "Admin tool to view and inspect multiple x509 Certificates";
    homepage = "https://github.com/mgit-at/cert-viewer";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mkg20001 ];
    mainProgram = "cert-viewer";
  };
}
