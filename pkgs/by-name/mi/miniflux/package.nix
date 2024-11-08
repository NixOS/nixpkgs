{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests, nix-update-script }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    rev = "refs/tags/${version}";
    hash = "sha256-FAeUhB05mDcdlHzJRLJR9mSKeqpKWed4Kxa89j/pjOQ=";
  };

  vendorHash = "sha256-FVm6kTZFp6qSUUuB2R4owzSxk+zfBWW1o7kOFadSS38=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestClient" ]; # skip client tests as they require network access

  ldflags = [
    "-s" "-w" "-X miniflux.app/v2/internal/version.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
    installManPage miniflux.1
  '';

  passthru = {
    tests = nixosTests.miniflux;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye emilylange ];
    mainProgram = "miniflux";
  };
}
