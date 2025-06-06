{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gomarkdoc
}:

buildGoModule rec {
  pname = "gomarkdoc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "princjef";
    repo = "gomarkdoc";
    rev = "v${version}";
    hash = "sha256-eMH+F1ZXAKHqnrvOJvCETm2NiDwY03IFHrDNYr3jaW8=";
  };

  subPackages = [ "cmd/gomarkdoc" ];

  vendorHash = "sha256-gCuYqk9agH86wfGd7k6QwLUiG3Mv6TrEd9tdyj8AYPs=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gomarkdoc;
    };
  };

  meta = with lib; {
    description = "Generate markdown documentation for Go (golang) code";
    homepage = "https://github.com/princjef/gomarkdoc";
    license = licenses.mit;
    maintainers = with maintainers; [ brpaz ];
    mainProgram = "gomarkdoc";
  };
}
