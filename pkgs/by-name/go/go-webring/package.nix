{
  buildGoModule,
  fetchgit,
  lib,
}:
buildGoModule {
  pname = "go-webring";
  version = "2024-12-18";

  src = fetchgit {
    url = "https://git.sr.ht/~amolith/go-webring";
    rev = "0b5b1bf21ff91119ea2dd042ee9fe94e9d1cd8d4";
    hash = "sha256-az6vBOGiZmzfsMjYUacXMHhDeRDmVI/arCKCpHeTcns=";
  };

  vendorHash = "sha256-3PnXB8AfZtgmYEPJuh0fwvG38dtngoS/lxyx3H+rvFs=";

  meta = {
    mainProgram = "go-webring";
    description = "Simple webring implementation";
    homepage = "https://git.sr.ht/~amolith/go-webring";
    license = lib.licenses.bsd2; # cc0 as well
    maintainers = [ lib.maintainers.kmein ];
  };
}
