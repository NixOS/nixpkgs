{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "prqlc";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "prql";
    repo = "prql";
    rev = version;
    hash = "sha256-PplIDbAWsFhfnhZ7G4XL7Y/+sfp6y1HQSbg5dAnZHHE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iHXrizKT1vMR8rGxEtCYdzmcHCD5eiy2XqZjql0cKG0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zlib
  ];

  env = {
    PYO3_PYTHON = "${python3}/bin/python3";
  };

  # we are only interested in the prqlc binary
  postInstall = ''
    rm -r $out/bin/compile-files $out/bin/mdbook-prql $out/lib
  '';

  meta = with lib; {
    description = "CLI for the PRQL compiler - a simple, powerful, pipelined SQL replacement";
    homepage = "https://github.com/prql/prql";
    changelog = "https://github.com/prql/prql/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
