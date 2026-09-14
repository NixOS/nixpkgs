{
  lib,
  fetchFromGitHub,
  crystal,
}:

crystal.buildCrystalPackage rec {
  pname = "shards";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "crystal-lang";
    repo = "shards";
    tag = "v${version}";
    hash = "sha256-Lij5ErYnX7zz/h+XYejLF/TRV4RMa2sG3TXBC0UOh5c=";
  };

  # we cannot use `make` or `shards` here as it would introduce a cyclical dependency
  format = "crystal";
  # the shards package only uses one dependency, which is github.com/crystal-lang/crystal-molinillo
  # but that dependency got vendored into the same crystal-lang/shards repository, so
  # a `shards.nix` file is no longer needed.
  # Reference: https://github.com/crystal-lang/shards/pull/663
  shardsFile = null;
  crystalBinaries.shards.src = "./src/shards.cr";

  # tries to execute git which fails spectacularly
  doCheck = false;

  meta = {
    description = "Dependency manager for the Crystal language";
    mainProgram = "shards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
    inherit (crystal.meta) homepage platforms;
  };
}
