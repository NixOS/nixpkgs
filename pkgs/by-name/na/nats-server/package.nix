{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.11.8";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats-server";
    rev = "v${version}";
    hash = "sha256-4kxiyxV44O+PtxTqmBmS12RkH1Rcru/EXSV7CY+8eo0=";
  };

  vendorHash = "sha256-+wQJijP3vOU7riz8xrPot0EecEU+KhZK9UQdcI72Vtg=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      swdunlop
      derekcollison
    ];
  };
}
