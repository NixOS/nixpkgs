{
  lib,
  fetchFromGitHub,
  crystal,
}:

crystal.buildCrystalPackage rec {
  pname = "shards";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "crystal-lang";
    repo = "shards";
    tag = "v${version}";
    hash = "sha256-LOdI389nVsFXkKPKco1C+O710kBlWImzCvdBBYEsWQQ=";
  };

  # we cannot use `make` or `shards` here as it would introduce a cyclical dependency
  format = "crystal";
  shardsFile = ./shards.nix;
  crystalBinaries.shards.src = "./src/shards.cr";

  # tries to execute git which fails spectacularly
  doCheck = false;

  meta = with lib; {
    description = "Dependency manager for the Crystal language";
    mainProgram = "shards";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (crystal.meta) homepage platforms;
  };
}
