{ lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "hickory-dns";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "v${version}";
    sha256 = "sha256-CfFEhZEk1Z7VG0n8EvyQwHvZIOEES5GKpm5tMeqhRVY=";
  };
  cargoHash = "sha256-fQKQa2g0sclFjJSTl5CN37Pzh5CfY5lY+npNFAzOZ9w=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  meta = with lib; {
    description = "A Rust based DNS client, server, and resolver";
    homepage = "https://hickory-dns.org/";
    maintainers = with maintainers; [ colinsane juaningan ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 mit ];
  };
}
