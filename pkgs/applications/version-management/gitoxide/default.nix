{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "0ap5ih4s99c4ah95mcafqsvy4yhfqab6vg1c6ydzfa4czczgcxff";
  };

  cargoSha256 = "0vj7g2jhvd5d37rcq02hval9axpciwyqyd10z2a0bsvw0r4bh943";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description =
      "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.syberant ];
  };
}
