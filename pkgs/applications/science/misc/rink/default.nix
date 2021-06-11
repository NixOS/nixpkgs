{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.6.1";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "1h93xlavcjvx588q8wkpbzph88yjjhhvzcfxr5nicdca0jnha5ch";
  };

  cargoSha256 = "0x4rvfnw3gl2aj6i006nkk3y1f8skyv8g0ss3z2v6qj9nhs7pyir";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ]
    ++ (if stdenv.isDarwin then [ libiconv Security ] else [ openssl ]);

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3Plus ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
