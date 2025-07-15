{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadow-tls";
  version = "0.2.25";

  src = fetchFromGitHub {
    owner = "ihciah";
    repo = "shadow-tls";
    rev = "v${version}";
    hash = "sha256-T+GPIrcME6Wq5sdfIt4t426/3ew5sUQMykYeZ6zw1ko=";
  };

  cargoHash = "sha256-1oJCdqBa1pWpQ7QvZ0vZaOd73R+SzR9OPf+yoI+RwCY=";

  RUSTC_BOOTSTRAP = 1;

  # network required
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ihciah/shadow-tls";
    description = "Proxy to expose real tls handshake to the firewall";
    license = licenses.mit;
    mainProgram = "shadow-tls";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
