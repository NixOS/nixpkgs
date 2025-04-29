{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-/jc9OEWxwcMFIdihlyxADHgZKumc/uOqkhjjN1mLw1U=";
  };

  vendorHash = "sha256-koWDlmlabDiwnlx+BTTtSQglu2lpccoTh17fRUC3pvg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata.";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = licenses.mit;
    maintainers = with maintainers; [ shift ];
  };
}
