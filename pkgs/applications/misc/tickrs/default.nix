{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OOsBo+NCfn++2XyfQVoeEPcbSv645Ng7g9s4W7X2xg4=";
  };

  cargoSha256 = "sha256-HAkJKqoz4vrY4mGFSz6sylV6DdrjWvPfwb4BiLWEyKY=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
