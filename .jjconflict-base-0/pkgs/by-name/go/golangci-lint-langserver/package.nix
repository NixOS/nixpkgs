{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "golangci-lint-langserver";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "nametake";
    repo = "golangci-lint-langserver";
    rev = "v${version}";
    sha256 = "sha256-jNRDqg2a5dXo7QI4CBRw0MLwhfpdGuhygpMoSKNcgC0=";
  };

  vendorHash = "sha256-tAcl6P+cgqFX1eMYdS8vnfdNyb+1QNWwWdJsQU6Fpgg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Language server for golangci-lint";
    homepage = "https://github.com/nametake/golangci-lint-langserver";
    license = licenses.mit;
    maintainers = with maintainers; [ kirillrdy ];
    mainProgram = "golangci-lint-langserver";
  };
}
