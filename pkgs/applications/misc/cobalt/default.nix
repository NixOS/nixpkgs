{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.19.6";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-6fsKEIgcBu0SE/f0TNfvTdpZX3zc5Bd0F1T82COOqVQ=";
  };

  cargoHash = "sha256-g25Pw3BlRbuaGjsQav6mU9zVyS1mVUKkgKDOILm8R6U=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
    mainProgram = "cobalt";
  };
}
