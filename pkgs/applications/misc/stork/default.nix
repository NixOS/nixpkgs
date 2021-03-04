{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "stork";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jameslittle230";
    repo = "stork";
    rev = "v${version}";
    sha256 = "sha256-pBJ9n1pQafXagQt9bnj4N1jriczr47QLtKiv+UjWgTg=";
  };

  cargoSha256 = "sha256-u8L4ZeST4ExYB2y8E+I49HCy41dOfhR1fgPpcVMVDuk=";

  meta = with lib; {
    description = "Impossibly fast web search, made for static sites";
    homepage = "https://github.com/jameslittle230/stork";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ chuahou ];
  };
}
