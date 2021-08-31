{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "wSvjPifnA8oc0vVmHBMdsMKzX7Gg6TdbPzIXl/SHqn8=";
  };

  cargoSha256 = "27LcoGBI4elt80uQkTwvToOyEmd2+/3ma5Y32OFrJaw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
