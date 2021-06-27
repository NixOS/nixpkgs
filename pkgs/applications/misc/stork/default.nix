{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "stork";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jameslittle230";
    repo = "stork";
    rev = "v${version}";
    sha256 = "sha256-rox8X+lYiiCXO66JemW+R2I6y/IxdK6qpaiFXYoL6nY=";
  };

  cargoSha256 = "sha256-ujmBAld6DCc1l+yUu9qhRF8pS5HoIlstcdPTeTAyyXs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Impossibly fast web search, made for static sites";
    homepage = "https://github.com/jameslittle230/stork";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ chuahou ];
  };
}
