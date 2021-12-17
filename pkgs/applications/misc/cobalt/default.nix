{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-uZcs3VkmpasFwgB7m1spTHi2W86tJt2kWlRTXAotvvo=";
  };

  cargoSha256 = "sha256-U2TVg2/SIOxaWs4EehTpcu47uDO/EA2dJK56k3I6F+0=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
