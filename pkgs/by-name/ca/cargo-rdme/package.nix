{ lib, rustPlatform, fetchCrate, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rdme";
  version = "1.4.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZveL/6iWxnEz13iHdTjDA4JT29CbvWjrIvblI65XuMM=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-8srwz5p9NY+ymDpqSvG68oIHibSurdtrjBkG6TrZO70=";

  meta = with lib; {
    description = "Cargo command to create the README.md from your crate's documentation";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${version}/release-notes.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
