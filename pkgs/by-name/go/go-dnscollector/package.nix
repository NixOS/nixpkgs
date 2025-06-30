{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-q12hMnSqA/KCkmiqsmBpvDmyHtuEWhMBTKwOOyw3Wfs=";
  };

  vendorHash = "sha256-TtlOwmNyO2/eQCajPBu6Pgdbuk4gacpgtcnr1vZgZdg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata.";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = licenses.mit;
    maintainers = with maintainers; [ shift ];
  };
}
