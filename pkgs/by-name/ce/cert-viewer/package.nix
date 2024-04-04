{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "cert-viewer";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mgit-at";
    repo = "cert-viewer";
    rev = "refs/tags/v${version}";
    hash = "sha256-q4FLKH0ZA/79zLo7dt+CSOjfKyygTiQKSuungQTtue0=";
  };

  vendorHash = "sha256-55zDUAe5s+03/OnDcK1DqmMUpFO2sBaVjEk6vbrHgzY=";

  meta = {
    description = "Admin tool to view and inspect multiple x509 Certificates";
    homepage = "https://github.com/mgit-at/cert-viewer";
    license = lib.licenses.apsl20;
    maintainers = [ lib.maintainers.mkg20001 ];
    mainProgram = "cert-viewer";
  };
}
