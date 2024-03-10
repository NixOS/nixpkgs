{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-W0XbNZDSeSK6oxOD1JeLNF+c6/6cy/WQrrmQbSKeqk4=";
  };

  cargoHash = "sha256-IM2SKovb8FYwA/c4R3N7M+oVuGfuc5sK+r6FP9YMk+I=";

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
