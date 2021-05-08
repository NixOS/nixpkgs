{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "stork";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jameslittle230";
    repo = "stork";
    rev = "v${version}";
    sha256 = "sha256-gPrXeS7XT38Dil/EBwmeKIJrmPlEK+hmiyHi4p28tl0=";
  };

  cargoSha256 = "sha256-9YKCtryb9mTPz9iWE7Iuk2SKgV0knWRbaouF+1DCjv8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Impossibly fast web search, made for static sites";
    homepage = "https://github.com/jameslittle230/stork";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ chuahou ];
  };
}
