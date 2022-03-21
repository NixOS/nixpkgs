{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "dht";
  version = "0.25";

  src = fetchFromGitHub {
    # Use transmission fork from post-0.25-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "25e12bb39eea3d433602de6390796fec8a8f3620";
    sha256 = "fksi8WBQPydgSlISaZMMnxzt4xN7/Hh7aN6QQ+g/L7s=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "BitTorrent DHT library";
    homepage = "https://github.com/transmission/dht";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
