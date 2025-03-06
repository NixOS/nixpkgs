{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  jsonfmt,
}:

buildGoModule rec {
  pname = "jsonfmt";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "jsonfmt";
    rev = "v${version}";
    hash = "sha256-4SNpW/+4S4sEwjM7b9ClqKqwqFFVbCVv5VnftGIHtjo=";
  };

  vendorHash = "sha256-6pCgBCwHgTRnLDNfveBEKbs7kiXSSacD0B82A2Sbl1U=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = jsonfmt;
    };
  };

  meta = with lib; {
    description = "Formatter for JSON files";
    homepage = "https://github.com/caarlos0/jsonfmt";
    changelog = "https://github.com/caarlos0/jsonfmt/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "jsonfmt";
  };
}
