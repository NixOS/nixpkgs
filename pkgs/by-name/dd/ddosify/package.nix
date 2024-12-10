{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ddosify";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "ddosify";
    repo = "ddosify";
    rev = "refs/tags/v${version}";
    hash = "sha256-5K/qXtdlDC09dEjRwYvoh9SapGLNmvywDMiNdwZDDTQ=";
  };

  vendorHash = "sha256-Wg4JzA2aEwNBsDrkauFUb9AS38ITLBGex9QHzDcdpoM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.GitVersion=${version}"
    "-X=main.GitCommit=unknown"
    "-X=main.BuildDate=unknown"
  ];

  # TestCreateHammerMultipartPayload error occurred - Get "https://upload.wikimedia.org/wikipedia/commons/b/bd/Test.svg"
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/ddosify -version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "High-performance load testing tool, written in Golang";
    mainProgram = "ddosify";
    homepage = "https://ddosify.com/";
    changelog = "https://github.com/ddosify/ddosify/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
