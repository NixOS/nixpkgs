{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, stdenv
, libiconv
, Security
, SystemConfiguration
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "sha256-UtQ9LcGE9mLowttAAwR1ujD+BSCosFk+GHQvDwG/CAQ=";
  };

  cargoSha256 = "sha256-0cZy7hOaREtdFB0Ww1VSV4ILpB0utSBcKlC3t9fhum8=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration ]
    else [ openssl ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    changelog = "https://github.com/Byron/gitoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ syberant ];
  };
}
