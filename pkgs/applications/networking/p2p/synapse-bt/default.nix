{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  name = "synapse-bt-unstable-${version}";
  version = "2018-06-04";

  src = fetchFromGitHub {
    owner = "Luminarys";
    repo = "synapse";
    rev = "ec8f23a14af21426ab0c4f8953dd954f747850ab";
    sha256 = "0d1rrwnk333zz9g8s40i75xgdkpz6a1j01ajsh32yvzvbi045zkw";
  };

  cargoSha256 = "1psrmgf6ddzqwx7gf301rx84asfnvxpsvkx2fan453v65819k960";

  buildInputs = [ pkgconfig openssl ];

  cargoBuildFlags = [ "--all" ];

  meta = with stdenv.lib; {
    description = "Flexible and fast BitTorrent daemon";
    homepage = https://synapse-bt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
