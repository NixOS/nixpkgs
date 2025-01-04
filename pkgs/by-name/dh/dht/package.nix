{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "dht";
  version = "0.27";

  src = fetchFromGitHub {
    # Use transmission fork from post-0.27-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "015585510e402a057ec17142711ba2b568b5fd62";
    sha256 = "m4utcxqE3Mn5L4IQ9UfuJXj2KkXXnqKBGqh7kHHGMJQ=";
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
