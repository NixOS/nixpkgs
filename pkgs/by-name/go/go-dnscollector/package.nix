{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-LQJxK2MZtFeFm5keNoNSDHXmxS8z9/fsCV02BGsph74=";
  };

  vendorHash = "sha256-nZheY/CbzDR/GB4Nu3xiWXsxrrvu/AKZE0gquBrfXXM=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = licenses.mit;
    maintainers = with maintainers; [ shift ];
  };
}
