{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "qt1IN/5+yw5lrQ00YsvXUcUXCxd97EtNf5JvxJVa7uc=";
  };

  cargoSha256 = "xQwY5w5NI6WO2QiouEigC3oC1A8XliNQ8iS2K1ADm4A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.syberant ];
  };
}
