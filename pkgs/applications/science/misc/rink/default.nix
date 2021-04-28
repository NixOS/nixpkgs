{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses }:

rustPlatform.buildRustPackage rec {
  version = "0.6.0";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "sha256-3uhKevuUVh7AObn2GDW2T+5wttX20SbVP+sFaFj3Jmk=";
  };

  cargoSha256 = "sha256-luJzIGdcitH+PNgr86AYX6wKEkQlsRhwwylo+hzeovE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ncurses ];

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3Plus ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
