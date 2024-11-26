{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  xq-xml,
}:

buildGoModule rec {
  pname = "xq";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "sibprogrammer";
    repo = "xq";
    rev = "v${version}";
    hash = "sha256-Xr5k7YBx8GjrBapmThpLnPPvzEP6mcQG4mKXxZaEan4=";
  };

  vendorHash = "sha256-UV6Z4GyeFPkiyhUll7hCFkt+iBdWAl02QdzYYX0N2e4=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.commit=${src.rev}"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = xq-xml;
    };
  };

  meta = with lib; {
    description = "Command-line XML and HTML beautifier and content extractor";
    mainProgram = "xq";
    homepage = "https://github.com/sibprogrammer/xq";
    changelog = "https://github.com/sibprogrammer/xq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
