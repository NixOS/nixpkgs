{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  version = "10.1.0";
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${version}";
    hash = "sha256-fPzdko8qcg9zcr79SrEakLqTFj9hDCakl6hTVpW9al8=";
  };

  cargoHash = "sha256-P8PT75TwdYeS9xJ7EEdIhlgHfd0VlIPUaLkM0SfRPq0=";

  # don't require qemu for aarch64-linux tests
  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
