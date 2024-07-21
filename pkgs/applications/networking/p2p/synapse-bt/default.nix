{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "synapse-bt";
  version = "unstable-2023-02-16";

  src = fetchFromGitHub {
    owner = "Luminarys";
    repo = "synapse";
    rev = "2165fe22589d7255e497d196c1d42b4c2ace1408";
    hash = "sha256-2irXNgEK9BjRuNu3DUMElmf2vIpGzwoFneAEe97GRh4=";
  };

  cargoHash = "sha256-TwXouPYM7Hg1HEr2KnEPScYFkC52PcQ5kb5aGP1gj9U=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  cargoBuildFlags = [ "--all" ];

  meta = with lib; {
    description = "Flexible and fast BitTorrent daemon";
    homepage = "https://synapse-bt.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ dywedir ];
  };
}
