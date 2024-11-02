{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests, nix-update-script }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    rev = "refs/tags/${version}";
    hash = "sha256-b4slACQl+3vDsioULVKscBhS8LvTxCUPDnO7GlT46CM=";
  };

  vendorHash = "sha256-PL5tc6MQRHloc3Dfw+FpWdqrXErFPjEb8RNPmHr7jSk=";

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
