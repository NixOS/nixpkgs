{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  openssl,
  pkg-config,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "duckscript_cli";
  version = "0.11.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-afxzZkmmYnprUBquH681VHMDs3Co9C71chNoKbu6lEY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  cargoHash = "sha256-ft6EUajAj+Zw3cEhdajwwHAaMaUf+/vtTuUYni8E+o0=";

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "duck";
  };
}
