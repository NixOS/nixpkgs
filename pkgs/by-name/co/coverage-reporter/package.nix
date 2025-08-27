{
  lib,
  crystal_1_17,
  fetchFromGitHub,
  ...
}:
crystal_1_17.buildCrystalPackage rec {
  pname = "coverage-reporter";
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "coverallsapp";
    repo = "coverage-reporter";
    tag = "v${version}";
    hash = "sha256-zNpHQJed3LRjTN/+UJEIj9N2ldLJsirO/NWvzp25SFo=";
  };

  shardsFile = ./shards.nix;
  doCheck = false;

  installPhase = "install -Dm755 bin/coveralls $out/bin/coveralls";

  meta = {
    changelog = "https://github.com/coverallsapp/coverage-reporter/releases/tag/${src.tag}";
    description = "Self-contained, universal coverage uploader binary";
    homepage = "https://github.com/coverallsapp/coverage-reporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quadradical ];
    mainProgram = "coveralls";
  };
}
