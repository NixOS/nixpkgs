{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-GUN/TgAlIl9/libhA+qqYDYHhc1ZDvDymR/Ac8Mev3c=";
  };

  cargoSha256 = "sha256-u6C19QA3gMzBZIRoNDnfu1p8zkirSQKjNSQrSb8+qvs=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
