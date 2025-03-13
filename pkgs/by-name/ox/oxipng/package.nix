{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  version = "9.1.4";
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${version}";
    hash = "sha256-cwujBgvGdNvD8vKp3+jNxcxkw/+M2FooNgsw+RejyrM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Z0otTCFwtGuSC1XBM3jcgGDFPZuMzQikZaYCnR+S6Us=";

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
