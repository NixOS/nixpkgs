{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-antLNQEOA20XxmmZHFQcs0VuLVfgM5V3wyXOYIX4hlk=";
  };

  vendorHash = "sha256-9EQr4lhv6+PkAnMJ6iWnBsK/SzZaOyVkSpqSYsX07LY=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata.";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = licenses.mit;
    maintainers = with maintainers; [ shift ];
  };
}
