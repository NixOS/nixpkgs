{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "synapse-bt";
  version = "unstable-2019-05-26";

  src = fetchFromGitHub {
    owner = "Luminarys";
    repo = "synapse";
    rev = "4a6e6c33b4c36eca89d216906d615797ba9a519e";
    sha256 = "0110y3lkzfhgvmdg6q71jyp5q9jjp2bzdb6cwnkp8c734c2k1gfw";
  };

  cargoSha256 = "0m4jigz6la3mf4yq217849ilcncb7d97mqyw2qicff4rbscdgf6h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  cargoBuildFlags = [ "--all" ];

  meta = with stdenv.lib; {
    description = "Flexible and fast BitTorrent daemon";
    homepage = https://synapse-bt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
