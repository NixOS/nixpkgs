{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.22";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B+fSB3aTXAc/EjKSaFR2clieLNFszA2U2BdMsYJRZFE=";
  };

  vendorHash = "sha256-0VkY1+3tlAfGDt+fhyMbmyT4TN0bw1HVJLi2+mivkrc=";

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
