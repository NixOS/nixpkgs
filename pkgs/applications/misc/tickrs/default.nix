{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mHMBhYI9pJkuK/6tCg1fXPjTfGFe0gkMzplesuFvl5M=";
  };

  cargoSha256 = "sha256-XmLobbVTYO8dA8YVtI/ntlD1RB9sO3poP6NBdDOPIlE=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
