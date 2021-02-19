{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F9PyJ2uvnKPcjHS4VeuVJuK48HiqqCG8kFzphGW4QyA=";
  };

  cargoSha256 = "sha256-0JSsCtAsqukFuwtbVS1L2jgLNBjquFBInjsJ1XVocjc=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
