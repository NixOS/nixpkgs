{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "dht";
  version = "0.27-unstable-2025-05-01";

  src = fetchFromGitHub {
    # Use transmission fork from post-0.27-transmission branch
    owner = "transmission";
    repo = "dht";
    rev = "38c9f261d9b58b76b9eaf85f84ec1b35151a1eac";
    hash = "sha256-Y6CQhHnXS0YiL9K2VQtHeksuqgqYj7yvGYQr5nVC+yc=";
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
