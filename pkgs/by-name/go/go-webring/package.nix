{
  buildGoModule,
  fetchgit,
  lib,
  nixosTests,
}:
buildGoModule {
  pname = "go-webring";
  version = "0-unstable-2024-12-18";

  src = fetchgit {
    url = "https://git.sr.ht/~amolith/go-webring";
    rev = "0b5b1bf21ff91119ea2dd042ee9fe94e9d1cd8d4";
    hash = "sha256-az6vBOGiZmzfsMjYUacXMHhDeRDmVI/arCKCpHeTcns=";
  };

  vendorHash = "sha256-3PnXB8AfZtgmYEPJuh0fwvG38dtngoS/lxyx3H+rvFs=";

  passthru.tests.nixos = nixosTests.go-webring;

  meta = {
    mainProgram = "go-webring";
    description = "Simple webring implementation";
    homepage = "https://git.sr.ht/~amolith/go-webring";
    license = with lib.licenses; [
      bsd2
      cc0
    ];
    maintainers = [ lib.maintainers.kmein ];
  };
}
