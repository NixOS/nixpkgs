{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0MwUpqmTrJ3/00Je9GfD70ET/ZctJwe5aqk5qp0jjRw=";
  };

  vendorHash = "sha256-uCNTUfYfMDjgM3RXsgAIzIFSuoHOCVks8aBR58RlU6Q=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      swdunlop
      derekcollison
    ];
  };
}
