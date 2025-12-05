{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  svu,
}:

buildGoModule rec {
  pname = "svu";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "svu";
    rev = "v${version}";
    sha256 = "sha256-3Rj+2ROo9TuWc2aZ8kkGeXH+PHjKva6nD7wlXHY/LQg=";
  };

  vendorHash = "sha256-2QznJ28lp/+f4MIbu4Wi5Kx46B7IIHGYGofY7B1OEjo=";

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
