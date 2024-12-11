{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.23";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XZPp8hRuweSUJaCXRgJJ2F8/cglWKMeDC/HZxxvL+V8=";
  };

  vendorHash = "sha256-ZpPxx7WwknlJTk1tMuH6L4oxQAFnd41y4pGky86qKR8=";

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
