{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  mockgen,
}:

buildGoModule rec {
  pname = "mockgen";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "mock";
    rev = "v${version}";
    sha256 = "sha256-gYUL+ucnKQncudQDcRt8aDqM7xE5XSKHh4X0qFrvfGs=";
  };

  vendorHash = "sha256-Cf7lKfMuPFT/I1apgChUNNCG2C7SrW7ncF8OusbUs+A=";

  env.CGO_ENABLED = 0;

  subPackages = [ "mockgen" ];

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.commit=unknown"
  ];

  passthru.tests.version = testers.testVersion {
    package = mockgen;
    command = "mockgen -version";
    version = ''
      v${version}
      Commit: unknown
      Date: 1970-01-01T00:00:00Z
    '';
  };

  meta = {
    description = "Mocking framework for the Go programming language";
    homepage = "https://github.com/uber-go/mock";
    changelog = "https://github.com/uber-go/mock/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bouk ];
    mainProgram = "mockgen";
  };
}
