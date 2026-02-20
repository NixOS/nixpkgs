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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prqlc";
  version = "0.13.10";

  src = fetchFromGitHub {
    owner = "prql";
    repo = "prql";
    rev = finalAttrs.version;
    hash = "sha256-SYIrME3iE1SpqjLvP/TxXXeiURfdrRSedN3FlcTwrt8=";
  };

  cargoHash = "sha256-4426LQ8X5iGPyjtyHnlmOQmYNHwmTvf6TowpCa463O4=";

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

  meta = {
    description = "CLI for the PRQL compiler - a simple, powerful, pipelined SQL replacement";
    homepage = "https://github.com/prql/prql";
    changelog = "https://github.com/prql/prql/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
