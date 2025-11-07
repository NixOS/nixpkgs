{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  svu,
}:

buildGoModule rec {
  pname = "svu";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "svu";
    rev = "v${version}";
    sha256 = "sha256-NzhVEChNsUkzGe1/M8gl1K0SD5nAQ/PrYUxGQKQUAtU=";
  };

  vendorHash = "sha256-xhNJsARuZZx9nhmTNDMB51VC0QgjZgOYFKLhLf+3b3A=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.builtBy=nixpkgs"
  ];

  # test assumes source directory to be a git repository
  postPatch = ''
    rm internal/git/git_test.go
  '';

  passthru.tests.version = testers.testVersion { package = svu; };

  meta = with lib; {
    description = "Semantic Version Util";
    homepage = "https://github.com/caarlos0/svu";
    maintainers = with maintainers; [ caarlos0 ];
    license = licenses.mit;
    mainProgram = "svu";
  };
}
