{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-cW9Pj4dTBZ0UmHvrWpx0SREBBaEIb2aaX2cdCUdlFLw=";
  };

  cargoHash = "sha256-/xkZuGyinQdUGWix/SRtJMJ5nmpXJu39/LxJoTHnT4Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
