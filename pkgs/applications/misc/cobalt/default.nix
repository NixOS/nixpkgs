{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.19.5";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-a9fo6qSLTVK6vC40nKwrpCvEvw1iIxQFmngkA3ttAdQ=";
  };

  cargoHash = "sha256-vr4G0L74qzsjpPKteV7wrW+pJGmbUVDLyc9MhSB1HfQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
    mainProgram = "cobalt";
  };
}
