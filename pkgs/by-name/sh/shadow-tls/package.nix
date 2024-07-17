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

  cargoHash = "sha256-w+DQeiQAtVsTw1VJhntX1FXymgS0fxsXiUmd6OjVWLQ=";

  RUSTC_BOOTSTRAP = 1;

  # network required
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ihciah/shadow-tls";
    description = "A proxy to expose real tls handshake to the firewall";
    license = licenses.mit;
    mainProgram = "shadow-tls";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
