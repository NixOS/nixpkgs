{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  CoreServices,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "synapse-bt";
  version = "unstable-2023-02-16";

  src = fetchFromGitHub {
    owner = "Luminarys";
    repo = "synapse";
    rev = "2165fe22589d7255e497d196c1d42b4c2ace1408";
    hash = "sha256-2irXNgEK9BjRuNu3DUMElmf2vIpGzwoFneAEe97GRh4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ebqUH01h4B3Aq3apSKpae8ncaFirbrZiDxjiQM9kzg4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreServices
      Security
    ];

  cargoBuildFlags = [ "--all" ];

  meta = with lib; {
    description = "Flexible and fast BitTorrent daemon";
    homepage = "https://synapse-bt.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ dywedir ];
  };
}
