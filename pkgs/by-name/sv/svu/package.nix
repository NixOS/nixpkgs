{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  svu,
}:

buildGoModule rec {
  pname = "svu";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "svu";
    rev = "v${version}";
    sha256 = "sha256-jnUVl34luj6kUyx27+zWFxKZMD+R1uzu78oJV7ziSag=";
  };

  vendorHash = "sha256-P5Ys4XjT5wKCbnxl3tKjpouiSZBFf/zfXKrV8MaGyMU=";

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
