{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  qemu,
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

  # See https://github.com/shssoichiro/oxipng/blob/14b8b0e93a/.cargo/config.toml#L5
  nativeCheckInputs = [ qemu ];

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
