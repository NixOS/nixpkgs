{ buildGoModule
, fetchFromGitHub
, lib
, testers
, mockgen
}:

buildGoModule rec {
  pname = "mockgen";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "mock";
    rev = "v${version}";
    sha256 = "sha256-1UlaM3IvKlplBW1pg5l+IXwirlierjDKqKsVwFt7EAw=";
  };

  vendorHash = "sha256-0OnK5/e0juEYrNJuVkr+tK66btRW/oaHpJSDakB32Bc=";

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

  meta = with lib; {
    description = "GoMock is a mocking framework for the Go programming language";
    homepage = "https://github.com/uber-go/mock";
    changelog = "https://github.com/uber-go/mock/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ bouk ];
    mainProgram = "mockgen";
  };
}
